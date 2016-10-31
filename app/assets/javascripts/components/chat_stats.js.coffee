React = require 'react'

@ChatStats = React.createClass
  getInitialState: ->
     conversations: []
     users: null
     bots: null
     userComments: []
     botComments: []

   componentWillMount: ->
     # Set the base info to use for the charts
     conversations = @state.conversations
     tempUser = @state.userComments
     tempBot = @state.botComments
     for conv in @props.convs
       parsedConv = JSON.parse conv
       conversations.push parsedConv
       for conversation in parsedConv.conversations
         for comment in conversation
           # Grab only the user/bot comments for analytics
           if comment.commentable_type == 'User'
             tempUser.push comment
           else if comment.commentable_type == 'Bot'
             tempBot.push comment
     @setState userComments: tempUser
     @setState botComments: tempBot
     @setState conversations: conversations

     # Initialize the google charts
     google.charts.load('current', {'packages':['corechart']})
     google.charts.setOnLoadCallback @drawChart

   drawChart: ->
     data = new google.visualization.DataTable()
     data.addColumn('string', 'User')
     data.addColumn('number', 'Comments')
     data.addRows (
       ['']
     )

  render: ->
    {div, h2} = React.DOM
    div className: 'chat-stats',
      div id: 'chart-1', ''

  module.exports = @ChatStats
