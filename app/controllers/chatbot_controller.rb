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

  $lightsOut = false

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

    if conv.present?
      # Check to see if the conversation intents decreased (create new conv.)
      # Or create a new one based off of time stamps (current implementation)
      elapsed_seconds = Time.now - Time.parse(conv.comments.last.created_at.to_s)
      if (elapsed_seconds / 60) > 15
        # Greater than 5 minutes, create a new conversation
        newConv = Conversation.create(entity: "blarg", correct: 1)
        # bot.comments.create(:body => "Hi there, I'm the Originate Bot. I came online 2 days ago so right now everything about me is new. But I'm learning every day to become a useful member of the team! Sort of like that movie Her, but with not so many moustaches...", :context => response["entities"], :correct => 1, conversation: newConv, :bot_id => bot.id)
        # bot.comments.create(:body => "Let's get to know each other. What's your name?", :context => response["entities"], :correct => 1, conversation: newConv, :bot_id => bot.id)
        # Check to see if you need to query Watson first to get initial comments

        # Query Watson API through http:post
        uri = URI.parse("https://gateway.watsonplatform.net/conversation/api/v1/workspaces/7ff7c931-6628-46f8-af4f-c6604a4424c6/message?version=2016-09-16")
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        request = Net::HTTP::Post.new(uri.request_uri)
        request.add_field('Content-Type', 'application/json')
        request.basic_auth("7abe25d1-9b85-4eec-b842-20a30ab01183", "UATIE1LNveQj")
        request.body = {'input': {'text': 'New Conversation'}}.to_json
        response = http.request(request)

        bot_json = ActiveSupport::JSON.decode(response.body)

        context = bot_json['context']
        new_context = ActiveSupport::JSON.encode context
        bot_responses = bot_json['output']['text']
        for bot_res in bot_responses
          botComment = bot.comments.create(:body => bot_res, :context => new_context, :correct => 1, conversation: newConv, :bot_id => bot.id)
        end

        newConv
      else
        # Current conversation is still going
        # Return the most recent conversation
        conv
      end
    else
      # Return a new conversation
      newConv = Conversation.create(entity: "blarg", correct: 1)
      # bot.comments.create(:body => "Hi there, I'm the Originate Bot. I came online 2 days ago so right now everything about me is new. But I'm learning every day to become a useful member of the team! Sort of like that movie Her, but with not so many moustaches...", :context => response["entities"], :correct => 1, conversation: newConv, :bot_id => bot.id)
      # bot.comments.create(:body => "Let's get to know each other. What's your name?", :context => response["entities"], :correct => 1, conversation: newConv, :bot_id => bot.id)

      # Query Watson API through http:post
      uri = URI.parse("https://gateway.watsonplatform.net/conversation/api/v1/workspaces/7ff7c931-6628-46f8-af4f-c6604a4424c6/message?version=2016-09-16")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Post.new(uri.request_uri)
      request.add_field('Content-Type', 'application/json')
      request.basic_auth("7abe25d1-9b85-4eec-b842-20a30ab01183", "UATIE1LNveQj")
      request.body = {'input': {'text': 'New Conversation'}}.to_json
      response = http.request(request)

      bot_json = ActiveSupport::JSON.decode(response.body)

      context = bot_json['context']
      new_context = ActiveSupport::JSON.encode context
      bot_responses = bot_json['output']['text']
      for bot_res in bot_responses
        botComment = bot.comments.create(:body => bot_res, :context => new_context, :correct => 1, conversation: newConv, :bot_id => bot.id)
      end

      newConv
    end
  end

  def ask_watson(query)
    require 'net/http'

    body = query.to_json

    user = get_user_by_cookie()
    bot = Bot.find_by(name: 'originate-questions')

    # Grab the current conversation, or new if one doesn't exist
    conv = get_recent_conv(bot, user)

    # Get the context of the previous conversation
    comments = conv.comments
    if comments.present?
      context = JSON.parse comments.last.context
      query['context'] = context

      # Check the previous context to see if actions need to be taken
      query = check_for_actions(query)

      body = ActiveSupport::JSON.encode query
    end

    # For now just broadcast to a single channel
    channel = "/bot-#{user.id}"

    userComment = user.comments.create(:body => query['input']['text'], :context => 'User Context', :correct => 1, conversation: conv, :bot_id => bot.id)
    data = {message: userComment}
    broadcast(channel, data)

    # Query Watson API through http:post
    uri = URI.parse("https://gateway.watsonplatform.net/conversation/api/v1/workspaces/7ff7c931-6628-46f8-af4f-c6604a4424c6/message?version=2016-09-16")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new(uri.request_uri)
    request.add_field('Content-Type', 'application/json')
    request.basic_auth("7abe25d1-9b85-4eec-b842-20a30ab01183", "UATIE1LNveQj")
    request.body = body
    response = http.request(request)

    bot_json = ActiveSupport::JSON.decode(response.body)

    context = bot_json['context']
    new_context = ActiveSupport::JSON.encode context
    bot_responses = bot_json['output']['text']
    for bot_res in bot_responses
      botComment = bot.comments.create(:body => bot_res, :context => new_context, :correct => 1, conversation: conv, :bot_id => bot.id)
      data = {message: botComment}
      broadcast(channel, data)
      sleep(1.5)
    end

  end

  def query
    query = params[:query]
    ask_watson(query)
    render :bot

    # user = get_user_by_cookie()
    # bot = Bot.find_by(name: 'originate-questions')
    # # Grab the current conversation, or new if one doesn't exist
    # conv = get_recent_conv(bot, user)

    # actions = {
    #   send: -> (request, response) {
    #     context = {}
    #     # if response['text'] == "I can't answer yet, but now I have a gift for you! Well, actually, it's a gif for you. :P"
    #     #   context = "{\"gif\": true}"
    #     # end
    #     botComment = bot.comments.create(:body => response["text"], :context => context, :correct => 1, conversation: conv, :bot_id => bot.id)
    #     data = {message: botComment}
    #     broadcast(channel, data)
    #     puts("sending... #{response['text']}")
    #   },
    #   getGif: -> (request) {
    #     # botComment = bot.comments.create(:body => '', :context => "{\"gif\": true}", :correct => 1, conversation: conv, :bot_id => bot.id)
    #     # data = {message: botComment}
    #     # broadcast(channel, data)
    #     sleep(4)
    #     return {}
    #   },
    #   lightsOut: -> (request) {
    #     entity = request['entities']['yesno'][0]['value']
    #     context = request['context']
    #
    #     lightChannel = '/lights'
    #
    #     #Broadcast the entity and context
    #     if entity == 'Yes'
    #       lightData = {lightsOut: true}
    #       context['yes'] = true
    #     else
    #       lightData = {lightsOut: false}
    #       context['no'] = true
    #     end
    #
    #     broadcast(lightChannel, lightData)
    #
    #     #Return the context so that it continues normally
    #     return context
    #   },
    #   getName: -> (request) {
    #     context = request['context']
    #     contact = getLastEntity(request, 'contact')
    #
    #     context['name'] = contact
    #     return context
    #   },
    #   checkName: -> (request) {
    #     context = request['context']
    #     contact = getLastEntity(request, 'contact')
    #
    #     bot_name = BotName.find_by(name: contact)
    #
    #     if bot_name.present?
    #       name_count = bot_name.count
    #       bot_name.update_attribute(:count, name_count+1)
    #
    #       context['oldName'] = contact
    #     else
    #       BotName.create(name: contact, count: 1)
    #
    #       context['newName'] = contact
    #     end
    #
    #     return context
    #   },
    #   getMessageCount: -> (request) {
    #     context = request['context']
    #     contact = getLastEntity(request, 'finish')
    #
    #     context = {}
    #
    #     context['numMessages'] = 8
    #
    #     return context
    #   }
    # }

    # access_token = '6Z74Y7HOXKI6YFLNQSBL25KAWDSNZGLJ'
    # wit = Wit.new(access_token: access_token, actions: actions)
    #
    # userComment = user.comments.create(:body => query, :context => 'User Context', :correct => 1, conversation: conv, :bot_id => bot.id)
    # data = {message: userComment}
    # broadcast(channel, data)
    #
    # max_steps = 8
    #
    # wit.run_actions(conv.id, query, {}, max_steps)

    # response = $wit.converse(conv.id, query, {})
    # p 'RESPONSE'
    # p '##################'
    # p response
    # # Second time to actually grab the response. It waits for you to perform actions
    # # response = client.converse('user-session-1', query, {})
    # if response["msg"] == '' || response["msg"] == nil
    #   # Couldn't find an entity, so the conversation ended. Start it again
    #   response = $wit.converse(conv.id, query, {})
    # end
    #
    # botComment = bot.comments.create(:body => response["msg"], :context => response["entities"], :correct => 1, conversation: conv, :bot_id => bot.id)
    # data = {message: botComment}
    # broadcast(channel, data)
  end

  def bot
    user = get_user_by_cookie()
    # user = User.first
    bot = Bot.find_by(name: 'originate-questions')
    conv = get_recent_conv(bot, user)

    @numConvs = Conversation.count
    # sql = "SELECT count(*) AS num_comments FROM comments WHERE (commentable_type = 'User')"
    # @answered = Comment.find_by_sql(sql)
    @answered = Comment.where(commentable_type: 'User').count
    @conversation = conv.comments
    @convId = user.id
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
      if currUser
        currUser
      else
        newUser = User.create(accessLevel: 1)
        cookies.permanent.signed[:user_id] = newUser.id
        newUser
      end
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
    Conversation.find_by_sql(query)
  end

  def broadcast(channel, data)
    base_url = request ? request.base_url : "http://localhost:3000"
    client = Faye::Client.new("#{base_url}/faye")
    client.publish(channel, data)
  end

  def getLastEntity(request, value)
    request['entities'][value][0]['value']
  end

  def check_for_actions(query)
    action = query['context']['action']
    if action == 'grabName'
      return grab_name(query)
    elsif action == 'grabBotName'
      return grab_bot_name(query)
    elsif action == 'getRandomResponse'
      return get_random_response(query)
    end
    return query
  end

  def grab_name(query)
    input = query['input']['text']
    query['context'][:entities] = []
    query['context']['entities'][0] = {'entity' => 'Contact', 'value' => 'Blaine Muri'} #['entity']['Contact']['value'] = input
    # no preprocessing for now
    query['context']['userName'] = input
    return query
  end

  def grab_bot_name(query)
    #Change it later so that it only stores in the next step
    input = query['input']['text'].downcase
    query['context']['botName'] = input

    bot_name = BotName.find_by(name: input)

    if bot_name.present?
      query['context']['newName'] = 'false'
      bot_name.update_attribute(:count, bot_name.count+1)
    else
      query['context']['newName'] = 'true'
      BotName.create(name: input, count: 1)
    end

    return query
  end

  def get_random_response(query)
    responses = [
      "Thanks! I've made a note of that.",
      "Another one for the database, nice.",
      "Can't wait to find the answer to that one!",
      "You're good at this question asking thing. Alex Trebek, eat your heart out.",
      "If there's an answer to that, I'll find it!",
      "No one expects the Originate inquisition!"
    ]
    query['context']['response'] = responses[rand(6)]
    return query
  end

end

# python /lib/assets/python/app.py
