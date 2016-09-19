class ChatbotController < ApplicationController
  def ask_watson(query)
    require 'net/http'
    require 'json'

    # This is a standard HTTP Post using the net/http built into rails
    # It mimics this curl command as per the Watson Conversation API standards
    # curl -u 0a64fe2a-b01a-43c2-98e4-401f4f5131df:BaWjpCOtXXce -H "Content-Type:application/json" -d "{\"input\": {\"text\": \"Hello\"}}" "https://gateway.watsonplatform.net/conversation/api/v1/workspaces/07e02c55-f1e9-4953-8cb2-e50bae764e3b/message?version=2016-07-11"

    # Replace the text with the user data and be sure to add context
    # into the body data
    @body = query.to_json

    uri = URI.parse("https://gateway.watsonplatform.net/conversation/api/v1/workspaces/19d05bd9-53a2-427f-9091-a74b885eef26/message?version=2016-07-11")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new(uri.request_uri)
    request.add_field('Content-Type', 'application/json')
    request.basic_auth("a4da0ece-5ee3-4e11-87ed-e6afe3ed8b8c", "IeUUcCDdkoMH")
    request.body = @body
    response = http.request(request)

    p response.body
    # Eventually access currentUser through rails
    user = User.first
    bot = Bot.first

    query = "SELECT \"conversations\".* FROM \"conversations\" INNER JOIN \"comments\" c1 ON c1.\"conversation_id\" = \"conversations\".\"id\" INNER JOIN \"comments\" c2 ON c2.\"conversation_id\" = \"conversations\".\"id\" WHERE (c1.commentable_id = #{user.id} AND c1.commentable_type = 'User') AND (c2.commentable_id = #{bot.id} AND c2.commentable_type = 'Bot') AND (\"conversations\".\"end\" IS NULL)"
    # .first will grab the most recent element
    conv = Conversation.find_by_sql(query).first

    p conv
    if conv.present?
      # Add them to the current conversation
      puts 'Conversation is present'
    else
      # Create a new conversation
      new_conv = Conversation.create(:entity => "blarg", :correct => 1)
      com_user = user.comments.create(:body => 'User Text', :context => 'User Context', :correct => 1, conversation: new_conv)
      com_bot = bot.comments.create(:body => 'Bot Text', :context => 'Bot Context', :correct => 1, conversation: new_conv)
    end

  end

  def query
    @query = params[:query]
    ask_watson(@query)
    render :bot
  end
end

# python /lib/assets/python/app.py
