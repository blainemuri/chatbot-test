React = require 'react'

@Botler = React.createClass
  getInitialState: ->
    page: 'Dashboard'
    bot: null
    content: {}
    id: 1
    conversation: null
    date: null

  setPage: (page) -> @setState page: page

  loadConversation: (conversation, date, page) ->
    @setState page: page
    @setState conversation: conversation
    @setState date: date
    setTimeout ( ->
      tl = new TimelineMax()
      tl.add('start')
      tl.fromTo('.show-log', .4, {opacity: 0, transform: "rotateY(90deg)"}, {opacity: 1, transform: "rotateY(0)"}, 'start')
        .staggerTo('.message', .3, {transform: "translateY(0)", opacity: 1}, .1, "start+.1")
    ), 200

  showEntities: (e, id, botId) ->
    data = JSON.parse @props.bots[id].trainingData
    @setState page: 'Entities'
    @setState content: data
    @setState id: botId

  showIntents: (e, id, botId) ->
    data = JSON.parse @props.bots[id].trainingData
    @setState page: 'Intents'
    @setState content: data
    @setState id: botId
    # @setCurrentBot id

  showDialogue: (e, id, botId) ->
    data = JSON.parse @props.bots[id].trainingData
    @setState page: 'Dialogue'
    @setState content: data.dialog_nodes
    @setState id: botId

  showNewBot: (e, id, botId) ->
    @setState page: 'Newbot'
    @setState id: botId

  submitTrainingData: (json, id, type) ->
    $.ajax
      method: 'POST'
      url: '/setTrainingData'
      #TODO 'type':type is probably cuasing errors with entity/synonym
      data: {'data': json, 'botId': id, 'type': type}

  render: ->
    {div, h3} = React.DOM
    div id: 'botler',
      div className: 'left-nav',
        div className: 'inner-nav',
          div
            className: 'heading'
            onClick: (e) => @setPage 'Dashboard'
            'Dashboard'
          div
            className: 'heading'
            onClick: (e) => @setPage 'Log'
            'Chat Log'
          div
            className: 'heading'
            onClick: (e) => @setPage 'Stats'
            'Stats'
          div className: 'line', ''
          for bot, id in @props.bots
            React.createElement BotMenu,
              key: id
              title: bot.name
              down: @props.down
              bot: bot
              id: id
              showEntities: @showEntities
              showIntents: @showIntents
              showDialogue: @showDialogue
              showNewBot: @showNewBot
      div className: 'right-content',
        if @state.page == 'Dashboard'
          React.createElement Dashboard, null
        else if @state.page == 'Log'
          React.createElement ChatLog,
            chatbot: @props.chatbot
            profile: @props.profile
            bots: @props.bots
            convs: @props.convs
            down: @props.down
            setConv: @loadConversation
        else if @state.page == 'Stats'
          React.createElement ChatStats,
            bots: @props.bots
            convs: @props.convs
            down: @props.down
        else if @state.page == 'Newbot'
          React.createElement NewBot,
            id: @state.id
        else if @state.page == 'Entities'
          React.createElement Entities,
            trainingData: @state.content
            down: @props.down
            submitTrainingData: @submitTrainingData
            id: @state.id
        else if @state.page == 'Intents'
          React.createElement Intents,
            trainingData: @state.content
            down: @props.down
            submitTrainingData: @submitTrainingData
            id: @state.id
        else if @state.page == 'Dialogue'
          React.createElement Dialogue,
            dialogue: @state.content
            id: @state.id
        else if @state.page == 'Conversation'
          div className: 'chat-container',
            div className: 'show-log-container',
              div className: 'header',
                h3 {}, "Chat Details for #{@state.date}"
              div className: 'conversation',
                @state.conversation.map (comment, id) =>
                  if comment.commentable_type == "Bot"
                    React.createElement BotMessage,
                      comment: comment
                      pic: @props.chatbot
                      admin: yes
                      key: id
                      animate: id
                  else
                    React.createElement UserMessage,
                      comment: comment
                      pic: @props.profile
                      key: id

module.exports = @Botler
