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

# GOOGLE CALENDAR API INFORMATION

# checkAuth: ->
#   gapi.auth.authorize {
#     'client_id': CLIENT_ID
#     'scope': SCOPES.join(' ')
#     'immediate': true
#   }, @handleAuthResult
#
# handleAuthResult: (authResult) ->
#   authorizeDiv = document.getElementById('authorize-div')
#   if authResult and !authResult.error
#     # Hide auth UI, then load client library.
#     authorizeDiv.style.display = 'none'
#     @loadCalendarApi()
#   else
#     # Show auth UI, allowing the user to initiate authorization by
#     # clicking authorize button.
#     authorizeDiv.style.display = 'inline'
#
# handleAuthClick: (event) ->
#   gapi.auth.authorize {
#     client_id: CLIENT_ID
#     scope: SCOPES
#     immediate: false
#   }, @handleAuthResult
#   return false
#
# loadCalendarApi: ->
#   gapi.client.load 'calendar', 'v3', @listUpcomingEvents
#
# listUpcomingEvents: ->
#   request = gapi.client.calendar.events.list(
#     'calendarId': 'primary',
#     'timeMin': (new Date).toISOString(),
#     'showDeleted': false,
#     'singleEvents': true,
#     'maxResults': 10,
#     'orderBy': 'startTime')
#   request.execute (resp) ->
#     events = resp.items
#     @appendPre 'Upcoming events:'
#     if events.length > 0
#       i = 0
#       while i < events.length
#         event = events[i]
#         when2 = event.start.dateTime
#         if !when2
#           when2 = event.start.date
#         @appendPre event.summary + ' (' + when2 + ')'
#         i++
#     else
#       @appendPre 'No upcoming events found.'
#     return
#
# appendPre: (message) ->
#   pre = document.getElementById('output')
#   textContent = document.createTextNode(message + '\n')
#   pre.app
