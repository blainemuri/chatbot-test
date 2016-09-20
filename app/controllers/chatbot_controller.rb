class ChatbotController < ApplicationController
  def get_conv()
    # Eventually access currentUser through rails
    user = User.first
    bot = Bot.first

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
    conv = get_conv()

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
    conv = get_conv()
    @conversation = conv.comments
  end

  def newbot
    # TODO: Change this to instead use the current bot
    bot = Bot.first
    bot.trainingData = params
    render :admin
  end
end

# python /lib/assets/python/app.py
