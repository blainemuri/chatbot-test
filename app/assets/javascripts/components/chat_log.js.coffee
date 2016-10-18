React = require 'react'

# LogTile = React.createFactory window.LogTile

@ChatLog = React.createClass
  getInitialState: ->
    showLog: no
    conversation: null
    date: null
    sort: 'all'
    ascending: false
    selectBots: false
    selectEntities: false

  showLoading: ->
    # $('#horizontal-center').css('opacity', '0');
    chat = document.getElementById 'horizontal-center'
    message = document.getElementById 'message'
    TweenMax.staggerTo('.message', .3, {transform: "translateY(0)", opacity: 1}, .1)
    tl = new TimelineMax()
    tl.add('start')
    tl.fromTo('#loading', .4, {scale: 1}, {scale: 2}, ease:Expo.easeInOut, 'start')
      .fromTo('#loading2', .3, {scale: .8}, {scale: 1.75}, ease:Expo.easeInOut, 'start')
      .to('#loading', .3, {scale: 1, opacity: 0}, 'start+.1')
      .to('#loading2', .4, {scale: .6, opacity: 0}, 'start+.1')
      .to(chat, .5, {top: 0, opacity: 1}, 'start+.2')
      .staggerTo('.log-tile', .2, {transform: "translateY(0)", opacity: 1}, .1, 'start+.2')
    tl.timeScale(1)

  componentDidMount: -> @showLoading()

  closeLog: ->
    TweenMax.to('.show-log', .2, {opacity: 0, transform: "rotateY(90deg)"})
    setTimeout ( =>
      @setState showLog: no
    ), 400

  openLog: (conversation, date) ->
    @setState showLog: yes
    @setState conversation: conversation
    @setState date: date
    # Make the call synchronous
    setTimeout ( ->
      tl = new TimelineMax()
      tl.add('start')
      tl.fromTo('.show-log', .4, {opacity: 0, transform: "rotateY(90deg)"}, {opacity: 1, transform: "rotateY(0)"}, 'start')
        .staggerTo('.message', .3, {transform: "translateY(0)", opacity: 1}, .1, "start+.1")
    ), 200

  getListOfConversations: (list, botId) ->
    if @state.sort == 'all'
      if @state.ascending
        list.conversations
      else
        list.conversations.reverse()
    else
      newList = []
      console.log botId
      console.log list.conversations[0][0].bot_id
      for conv in list.conversations
        if conv[0].bot_id == botId
          newList.push conv
      newList

  selectBots: -> @setState selectBots: !@state.selectBots

  selectEntities: -> @setState selectEntities: !@state.selectEntities

  setBot: (name, e) ->
    e.stopPropagation()
    e.preventDefault()
    @setState sort: name

  render: ->
    {div, a, h3, img, span} = React.DOM
    div className: "bot-log-outer",
      div className: 'log-options',
        div className: 'floated-inner',
          div
            className: 'sort-by'
            onClick: @selectBots
            div className: 'inner-sort',
              div className: 'type', 'All Bots'
              img
                className: 'arrow'
                src: @props.down
                alt: ''
            if @state.selectBots
              for bot, id in @props.bots
                React.createFactory(BotOption)
                  name: bot.name
                  key: id
                  setOption: @setBot
                  img: null
                  down: @props.down
          div
            className: 'sort-by'
            onClick: @selectEntities
            div className: 'inner-sort',
              div className: 'type', 'All Entities'
              img
                className: 'arrow'
                src: @props.down
                alt: ''
            # if @state.selectEntities
            #   console.log JSON.parse(conversation)
      if @state.showLog
        div className: 'show-log',
          div className: 'log-mask', ''
          div className: 'show-log-container',
            div className: 'header',
              h3 {}, "Chat Details for #{@state.date}"
              div
                className: 'close'
                onClick: @closeLog
                'Close'
            div className: 'conversation',
              @state.conversation.map (comment, id) =>
                if comment.commentable_type == "Bot"
                  React.createElement BotMessage,
                    text: comment.body
                    pic: @props.chatbot
                    key: id
                else
                  React.createElement UserMessage,
                    text: comment.body
                    pic: @props.profile
                    key: id
      div
        id: 'loading'
      div
        id: 'loading2'
      div
        id: 'horizontal-center',
        div className: 'log-container',
          @props.convs.map (conversation) =>
            parsedConversation = JSON.parse conversation
            list = @getListOfConversations parsedConversation, parsedConversation.bot_id
            for conv, id in list
              React.createFactory(LogTile)
                profile: @props.profile
                open: @openLog
                key: id
                conversation: conv
                bots: @props.bots
                botId: parsedConversation.bot_id
              # profile: @props.profile
              # open: @props.openLog
            # React.createElement LogTile
            #   profile: @props.profile
            #   open: @openLog
            #   key: id
            #   conversation: conversation

module.exports = @ChatLog
