React = require 'react'
# ConversationV1 = require 'watson-developer-cloud/conversation/v1'
# conversation = new ConversationV1({
#   username: "0a64fe2a-b01a-43c2-98e4-401f4f5131df"
#   password: "BaWjpCOtXXce"
#   version_date: '2016-07-01'
#   })
# fs = require 'fs'
# readline = require 'readline'
# google = require 'googleapis'
# googleAuth = require 'google-auth-library'

# CLIENT_ID = '895257639850-8dn4t6msml001fvpr5rdljr5qtsj2ibn.apps.googleusercontent.com'
# SCOPES = ["https://www.googleapis.com/auth/calendar"]
# WATSON = "https://watson-api-explorer.mybluemix.net/conversation/api/v1/workspaces/07e02c55-f1e9-4953-8cb2-e50bae764e3b/message?"

@Chatbot = React.createClass

  getInitialState: ->
    context: {}
    text: ""

  handleSubmit: (e) ->
    e.preventDefault()
    console.log "send to watson!"

    # HOW TO SEND WATSON THE API DATA VIA HTTP:POST
    # $.ajax
    #   url: '/chatbot'
    #   data: {'query': {'input': {'text': @state.text}}}
    #   method: 'POST'
    # .done (response) =>
    #   @setState text: ""
    # .fail ->
    #   alert 'Error sending message!'

  handleChange: (e) -> @setState text: e.target.value

  render: ->
    {div, span, pre, button, input, form} = React.DOM
    div className: 'chat-container',
      form
        id: 'chatbot'
        onSubmit: @handleSubmit
        input
          type: 'text'
          name: 'botquery'
          id: 'bot-query'
          onChange: @handleChange

module.exports = @Chatbot
