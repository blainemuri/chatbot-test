React = require 'react'

# LogTile = React.createFactory window.LogTile

@ChatLog = React.createClass
  getInitialState: ->
    showLog: no
    conversation: null
    date: null

  componentDidMount: ->
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

  render: ->
    {div, a, h3} = React.DOM
    div className: "bot-log-outer",
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
              JSON.parse(@state.conversation).conversations.map (comment, id) =>
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
          @props.convs.map (conversation, id) =>
            React.createFactory(LogTile)
              profile: @props.profile
              open: @openLog
              key: id
              conversation: conversation
              bots: @props.bots
              # profile: @props.profile
              # open: @props.openLog
            # React.createElement LogTile
            #   profile: @props.profile
            #   open: @openLog
            #   key: id
            #   conversation: conversation

module.exports = @ChatLog
