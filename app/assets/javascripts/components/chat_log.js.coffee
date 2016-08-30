React = require 'react'

@ChatLog = React.createClass
  getInitialState: ->
    showLog: no

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

  openLog: ->
    @setState showLog: yes
    # Make the call synchronous
    setTimeout ( ->
      console.log "blah"
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
              h3 {}, 'Chat Details for June 18, 2016'
              div
                className: 'close'
                onClick: @closeLog
                'Close'
            div className: 'conversation',
              React.createElement BotMessage,
                text: 'Welcome to Chat Botler, nice to meet you!'
                pic: @props.chatbot
              React.createElement UserMessage,
                text: "Hey how's it going, Mr. Chat Botler?"
                pic: @props.profile
              React.createElement BotMessage,
                text: 'Well! Always a good day as a bot! What can I help you with?'
                pic: @props.chatbot
              React.createElement UserMessage,
                text: "Book me a room in Marvin for 2pm tomorrow"
                pic: @props.profile
              React.createElement BotMessage,
                text: 'How long would you like to book the room?'
                pic: @props.chatbot
              React.createElement UserMessage,
                text: "1 hour"
                pic: @props.profile
              React.createElement BotMessage,
                text: "I've booked you Marvin for 1 hour at 2pm tomorrow!"
                pic: @props.chatbot
              React.createElement UserMessage,
                text: "Thanks!"
                pic: @props.profile
              React.createElement BotMessage,
                text: "You're welcome"
                pic: @props.chatbot
              React.createElement UserMessage,
                text: "/findthebots"
                pic: @props.profile
              React.createElement BotMessage,
                text: "Question number 1. This famous Rapbot is named after a domesticated animal. He won a grammy in 2014."
                pic: @props.chatbot
              React.createElement UserMessage,
                text: "Snoop Botty Bot?"
                pic: @props.profile
              React.createElement BotMessage,
                text: "Wow! That was great. Do you want to add the bot to your collection?"
                pic: @props.chatbot
              React.createElement UserMessage,
                text: "yes!"
                pic: @props.profile
      div
        id: 'loading'
      div
        id: 'loading2'
      div
        id: 'horizontal-center',
        div className: 'log-container',
          React.createElement LogTile, profile: @props.profile, open: @openLog
          React.createElement LogTile, profile: @props.profile, open: @openLog
          React.createElement LogTile, profile: @props.profile, open: @openLog
          React.createElement LogTile, profile: @props.profile, open: @openLog
          React.createElement LogTile, profile: @props.profile, open: @openLog
          React.createElement LogTile, profile: @props.profile, open: @openLog
          React.createElement LogTile, profile: @props.profile, open: @openLog
          React.createElement LogTile, profile: @props.profile, open: @openLog

module.exports = @ChatLog
