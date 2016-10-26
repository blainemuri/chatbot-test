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
    allConvs: []
    organize: 'date'

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

  componentWillMount: ->
    temp = []
    @props.convs.map (conversation) ->
      parsed = JSON.parse conversation
      user = parsed.user
      parsed.conversations.map (singleConv) ->
        singleConv[0].user = user
        temp.push singleConv
    # Store all conversations as a double array, no bot associated other than
    # with each comment itself
    @setState allConvs: temp

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

  getListOfConversations: (conv, botId) ->
    if @state.sort == 'all'
      if @state.ascending
        conv.conversations
      else
        conv.conversations.reverse()
    else
      newList = []
      # if conv.bot_id == @state.sort

      # for conv in list.conversations
      #   console.log conv
      #   console.log @state.sort
      #   if conv.bot_id == @state.sort
      #     newList.push conv
      # newList

  selectBots: -> @setState selectBots: !@state.selectBots

  selectEntities: -> @setState selectEntities: !@state.selectEntities

  setBot: (id, e) -> @setState sort: id

  sortByDate: (a, b) -> b[..].pop().created_at - a[..].pop().created_at

  # sortByBot: (a) -> a[..].pop().bot_id == @state.sort

  showConvsWithOptions: ->
    temp = @state.allConvs

    # Organize all conversations by date, not bot
    if @state.organize == 'date'
      temp = temp.sort(@sortByDate)
      if @state.sort !=  "all"
        newTemp = []
        temp.map (conv) =>
          if conv[0].bot_id == @state.sort
            newTemp.push conv
        temp = newTemp

    # Return the lsit with all of the options
    temp

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
                  id: bot.id
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
      div
        id: 'loading'
      div
        id: 'loading2'
      div
        id: 'horizontal-center',
        div className: 'log-container',
          @showConvsWithOptions().map (conversation, id) =>
            React.createFactory(LogTile)
              profile: @props.profile
              open: @openLog
              key: id
              conversation: conversation
              bots: @props.bots
              botId: conversation[0].bot_id

module.exports = @ChatLog
