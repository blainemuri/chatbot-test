require 'json'

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

    user = User.first
    bot = nil

    if currBot = Bot.where(:name => bot_name).first
      # Add to the current bot
      bot = currBot
    else
      # Create a new bot
      bot = Bot.create(name: bot_name)
    end

    # Grab the current conversation for this bot
    conv = get_conv(Bot.first)

    # Add in the messages
    user.comments.create(:body => user_message, :context => 'User Context', :correct => 1, conversation: conv)
    bot.comments.create(:body => bot_message, :context => 'Bot Context', :correct => 1, conversation: conv)

    render :admin
  end

  def get_conv(bot)
    # Eventually access currentUser through rails
    user = User.first

    query = "SELECT \"conversations\".* FROM \"conversations\" INNER JOIN \"comments\" c1 ON c1.\"conversation_id\" = \"conversations\".\"id\" INNER JOIN \"comments\" c2 ON c2.\"conversation_id\" = \"conversations\".\"id\" WHERE (c1.commentable_id = #{user.id} AND c1.commentable_type = 'User') AND (c2.commentable_id = #{bot.id} AND c2.commentable_type = 'Bot') AND (\"conversations\".\"end\" IS NULL)"
    # .first will grab the most recent element
    conv = Conversation.find_by_sql(query).first

    if conv.present?
      # Check to see if the conversation intents decreased (create new conv.)
      # Return the most recent conversation
      conv
    else
      # Return a new conversation
      Conversation.create(entity: "blarg", correct: 1)
    end
  end

  def ask_watson(query)
    require 'net/http'
    require 'json'

    @body = query.to_json

    # comments = conv.comments

    # Get the context of the previous conversation
    # if comments.present?
    #   context = comments.last.context
    #   p "context: " + @body
    #   @body['context'] = context
    # end

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

    user = User.first
    bot = Bot.first
    # Grab the current conversation, or new if one doesn't exist
    conv = get_conv(Bot.first)

    com_user = user.comments.create(:body => query['input']['text'], :context => 'User Context', :correct => 1, conversation: conv)
    com_bot = bot.comments.create(:body => bot_json['output']['text'].last, :context => response.body, :correct => 1, conversation: conv)
  end

  def query
    @query = params[:query]
    ask_watson(@query)
    render :bot
  end

  def bot
    user = User.first
    bot = Bot.first
    conv = get_conv(bot)
    @conversation = conv.comments
  end

  # TODO: When creating a new bot, add the entities/intents to their respective records
  def newbot
    # TODO: Change this to instead use the current bot
    bot = Bot.first
    bot.update_attribute(:trainingData, params[:data])
    render :admin
  end

  def admin
    @bots = Bot.all
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
    bot = Bot.find_by(id: params[:botId])
    p bot
    bot.update_attribute(:trainingData, new_data)

    key, val = params[:type].first
    p '######################'
    if key == 'entity'
      addNewEntity(params[:botId], val)
    elsif key == 'intent'
      addNewIntent(params[:botId], val)
    end

    render :admin
  end

  private

  # Possible Data Types
  # entity -> value -> synonym
  # intent -> example

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
    p id
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

end

# python /lib/assets/python/app.py
