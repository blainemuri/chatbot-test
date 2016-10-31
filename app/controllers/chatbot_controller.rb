require 'json'
require 'time'
require 'date'
require 'socket'
require 'resolv'
require 'faye'

class ChatbotController < ApplicationController
  # Allow for adminBot to send posts to /adminBot
  # TODO: DEFINITELY FIX THIS!!!!! ANYTHING CAN COME IN AT THIS POINT
  # TODO: LIKE SERIOUSLY, SOME RANDOM PERSON CAN POST ANYTHING HERE
  protect_from_forgery except: :adminBot
  skip_before_action :verify_authenticity_token, :only => :adminBot

  def adminBot
    bot_name = params["botname"]
    bot_message = params["data"]["botMessage"]
    user_message = params["data"]["userMessage"]
    email = params["data"]["email"]

    user = getUser(email)
    bot = getBot(bot_name)

    # Grab the current conversation for this bot
    conv = get_recent_conv(bot, user)

    # Add in the messages
    user.comments.create(:body => user_message, :context => 'User Context', :correct => 1, conversation: conv, bot_id: bot.id)
    bot.comments.create(:body => bot_message, :context => 'Bot Context', :correct => 1, conversation: conv, bot_id: bot.id)

    render :admin
  end

  def rateComment
    p params["correct"]
    comment = Conversation.find(params["conversation"]).comments.find(params["id"])
    comment.update_attribute(:correct, params["correct"])

    render :bot
  end

  def get_recent_conv(bot, user)
    # This grabs the most recent conversation
    conv = get_bot_user_convs(bot, user).last
    p 'GETTING THE LAST CONVERSATION'
    p conv

    if conv.present?
      # Check to see if the conversation intents decreased (create new conv.)
      # Or create a new one based off of time stamps (current implementation)
      elapsed_seconds = Time.now - Time.parse(conv.comments.last.created_at.to_s)
      if (elapsed_seconds / 60) > 15
        # Greater than 5 minutes, create a new conversation
        Conversation.create(entity: "conversation", correct: 1)
      else
        # Current conversation is still going
        # Return the most recent conversation
        conv
      end
    else
      # Return a new conversation
      Conversation.create(entity: "blarg", correct: 1)
    end
  end

  def ask_watson(query)
    require 'net/http'

    @body = query.to_json

    # comments = conv.comments

    # Get the context of the previous conversation
    # if comments.present?
    #   context = comments.last.context
    #   p "context: " + @body
    #   @body['context'] = context
    # end

    user = get_user_by_cookie()
    bot = Bot.find_by(name: 'originate')
    # Grab the current conversation, or new if one doesn't exist
    conv = get_recent_conv(bot, user)

    # For now just broadcast to a single channel
    channel = '/bot'

    userComment = user.comments.create(:body => query['input']['text'], :context => 'User Context', :correct => 1, conversation: conv, :bot_id => bot.id)
    data = {message: userComment}
    broadcast(channel, data)

    # Query Watson API through http:post
    uri = URI.parse("https://gateway.watsonplatform.net/conversation/api/v1/workspaces/19d05bd9-53a2-427f-9091-a74b885eef26/message?version=2016-09-16")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new(uri.request_uri)
    request.add_field('Content-Type', 'application/json')
    request.basic_auth("a4da0ece-5ee3-4e11-87ed-e6afe3ed8b8c", "IeUUcCDdkoMH")
    request.body = @body
    response = http.request(request)

    bot_json = ActiveSupport::JSON.decode(response.body)
    context = bot_json['context']

    botComment = bot.comments.create(:body => bot_json['output']['text'].last, :context => response.body, :correct => 1, conversation: conv, :bot_id => bot.id)
    data = {message: botComment}
    broadcast(channel, data)

    p '##############################'
    newContext = JSON.parse botComment['context']
    if newContext['intents'][0]['intent'] == 'create_timer'
      num = newContext['entities'][0]['value'].to_i
      sleep(num)

      newContext['timer_done'] = 1
      newBody = JSON.parse @body
      newBody['context'] = newContext

      botComment = bot.comments.create(:body => 'Time is up!', :context => newBody, :correct => 1, conversation: conv, :bot_id => bot.id)
      data = {message: botComment}
      broadcast(channel, data)

      # # Query watson again to get the response
      # newContext['timer_done'] = 1
      # new_http = Net::HTTP.new(uri.host, uri.port)
      # new_http.use_ssl = true
      # new_http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      #
      # # request.body =
      # newBody = JSON.parse @body
      # newBody['context'] = newContext
      # newBody['input']['text'] = ''
      # newRequest = request
      # newRequest.body = ActiveSupport::JSON.encode(newBody)
      # newResponse = new_http.request(newRequest)
      # decoded = ActiveSupport::JSON.decode(newResponse.body)
    end
    # if context["intents"][0]["intent"] == 'create_timer'
    #   p '##############################'
    # end
    # if data.message.commentable_type == 'Bot'
    #   context = JSON.parse data.message.context
    #   if context.intents[0].intent == 'create_timer'
    #     num = parseInt context.entities[0].value
    #     setTimeout
  end

  def query
    @query = params[:query]
    ask_watson(@query)
    render :bot
  end

  def bot
    user = get_user_by_cookie()
    # user = User.first
    bot = Bot.find_by(name: 'originate')
    conv = get_recent_conv(bot, user)
    @conversation = conv.comments
  end

  # TODO: When creating a new bot, add the entities/intents to their respective records
  def newbot
    bot = Bot.find_by(id: params[:botId])
    bot.update_attribute(:trainingData, params[:data])
    render :admin
  end

  def admin
    @bots = Bot.all
    users = User.all
    @convs = []
    # get_user_stats()
    # @stats = get_user_stats()
    for user in users
      for bot in @bots
        conversations = get_bot_user_convs(bot, user)
        hash = {}
        hash["bot_id"] = bot.id
        hash["user"] = user.id
        hash["conversations"] = []

        for conv in conversations
          comments = []
          coms = conv.comments.all

          coms.each do |com|
            temp = com.as_json
            temp["created_at"] = temp["created_at"].to_f * 1000
            # TODO: Need to fix this later so that it parses it only if it can
            # if temp["commentable_type"] == "Bot"
            #   p '##########################'
            #   p temp["context"]
            #   temp["context"] = ActiveSupport::JSON.decode temp["context"]
            # end
            comments.append temp
          end

          # Add in the comments to the list of conversations for that bot
          hash["conversations"].append comments

        end

        @convs.append ActiveSupport::JSON.encode hash
      end
    end
    # p @convs[0].as_json
  end
  #
  # def newentity
  #   entity = params
  #   bot = Bot.first
  #   training_data = bot.trainingData
  #   training_data['entities'][entity] = {}
  #   bot.update_attribute(:trainingData, training_data)
  # end

  def setTrainingData
    new_data = params[:data]
    bot = Bot.find params[:botId]
    bot.update_attribute(:trainingData, new_data)

    key, val = params[:type].first
    if key == 'entity'
      addNewEntity(params[:botId], val)
    elsif key == 'intent'
      addNewIntent(params[:botId], val)
    end

    render :admin
  end

  private

  def addNewEntity(id, entity)
    bot = Bot.find_by(id: id)
    if Entity.where(name: entity).present?
      if !bot.entities.exists?(name: entity)
        # Entity does not exist, so let's create it
        # TODO: This needs to change to where it's associated with the current entity
        bot.enitites.create(name: entity)
      end
      # Do nothing if the entity already exists within the bot
    else
      bot.entities.create(name: entity)
    end
  end

  def addNewIntent(id, intent)
    bot = Bot.find_by(id: id)
    if Intent.where(name: intent).present?
      if !bot.intents.exists?(name: intent)
        # Intent does not exists, so let's create it
        # TODO: This needs to change to where it's associated witih the current intent
        bot.intents.create(name: intent)
      end
      # Do nothing if the intent already exists within the bot
    else
      bot.intents.create(name: intent)
    end
  end

  def getUser(username)
    if user = User.where(:username => username).first
      user
    else
      user = User.create(username: username, accessLevel: 0)
      user
    end
  end

  def get_user_by_cookie
    if user = cookies.permanent.signed[:user_id]
      currUser = User.find_by(id: user)
      currUser
    else
      newUser = User.create(accessLevel: 1)
      cookies.permanent.signed[:user_id] = newUser.id
      newUser
    end
  end

  def getBot(name)
    bot = nil

    if currBot = Bot.where(:name => name).first
      # Add to the current bot
      bot = currBot
    else
      # Create a new bot
      bot = Bot.create(name: name)
    end
  end

  def get_user_stats
    users = User.all
    for user in users
      p user.comments
    end
  end

  # def get_all_user_convs(user)
  #   query = "SELECT DISTINCT \"conversations\".* FROM \"conversations\" INNER JOIN \"comments\" c1 ON c1.\"conversation_id\" = \"conversations\".\"id\" INNER JOIN \"comments\" c2 ON c2.\"conversation_id\" = \"conversations\".\"id\" WHERE (c1.commentable_type = 'User') AND (c2.commentable_id = #{bot.id} AND c2.commentable_type = 'Bot') AND (\"conversations\".\"end\" IS NULL) ORDER BY id ASC"
  #   Conversation.find_by_sql(query)
  # end

  def get_all_convs_for_bot(bot)
    # User.all.each do |user|
    query = "SELECT DISTINCT \"conversations\".* FROM \"conversations\" INNER JOIN \"comments\" c1 ON c1.\"conversation_id\" = \"conversations\".\"id\" INNER JOIN \"comments\" c2 ON c2.\"conversation_id\" = \"conversations\".\"id\" WHERE (c1.commentable_type = 'User') AND (c2.commentable_id = #{bot.id} AND c2.commentable_type = 'Bot') AND (\"conversations\".\"end\" IS NULL) ORDER BY id ASC"
    Conversation.find_by_sql(query)
  end

  def get_bot_user_convs(bot, user)
    query = "SELECT DISTINCT \"conversations\".* FROM \"conversations\" INNER JOIN \"comments\" c1 ON c1.\"conversation_id\" = \"conversations\".\"id\" INNER JOIN \"comments\" c2 ON c2.\"conversation_id\" = \"conversations\".\"id\" WHERE (c1.commentable_id = #{user.id} AND c1.commentable_type = 'User') AND (c2.commentable_id = #{bot.id} AND c2.commentable_type = 'Bot') AND (\"conversations\".\"end\" IS NULL) ORDER BY id ASC"
    conv = Conversation.find_by_sql(query)
  end

  def broadcast(channel, data)
    base_url = request ? request.base_url : "http://localhost:3000"
    client = Faye::Client.new("#{base_url}/faye")
    client.publish(channel, data)
  end

end

# python /lib/assets/python/app.py
