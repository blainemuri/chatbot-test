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

    uri = URI.parse("https://gateway.watsonplatform.net/conversation/api/v1/workspaces/bcee86e6-d69c-4eb9-be40-a3ce769450df/message?version=2016-07-11")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new(uri.request_uri)
    request.add_field('Content-Type', 'application/json')
    request.basic_auth("b42cc929-33b8-462c-9cf7-d42cba172c56", "CXMTz6p7nv2w")
    request.body = @body
    response = http.request(request)

    puts response.body
  end

  def query
    @query = params[:query]
    ask_watson(@query)
    render :bot
  end
end

# python /lib/assets/python/app.py
