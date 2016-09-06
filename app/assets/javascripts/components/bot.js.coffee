React = require 'react'

@Bot = React.createClass
  getInitialState: ->
    context: {}
    text: ""
    dark: no

  handleSubmit: (e) ->
    e.preventDefault()
    $.ajax
      url: '/bot'
      data: {'query': {"input": {"text": @state.text}}}
      method: 'POST'
    .done (response) =>
      @setState text: ""
    .fail ->
      alert 'Error sending message!'

  handleChange: (e) -> @setState text: e.target.value

  toggleDark: -> @setState dark: !@state.dark

  componentWillUnmount: ->
    console.log "blah"
    TweenMax.to('#horizontal-center', .05, {opacity: 0})

  componentDidMount: ->
    conversation = document.getElementById 'conv-scroll'
    conversation.scrollTop = conversation.scrollHeight
    chat = document.getElementById 'horizontal-center'
    message = document.getElementById 'message'
    tl = new TimelineMax()
    tl.add('start')
    tl.fromTo('#loading', .4, {scale: 1}, {scale: 2}, ease:Expo.easeInOut, 'start')
      .fromTo('#loading2', .3, {scale: .8}, {scale: 1.75}, ease:Expo.easeInOut, 'start')
      .to('#loading', .3, {scale: 1, opacity: 0}, 'start+.1')
      .to('#loading2', .4, {scale: .6, opacity: 0}, 'start+.1')
      .to(chat, .5, {top: 0, opacity: 1}, 'start+.2')
      .staggerTo('.message', .2, {transform: "translateY(0)", opacity: 1}, .05, 'start+.2')
    tl.timeScale(1)

  render: ->
    {div, input, img, form} = React.DOM
    div className: "bot-chat-outer #{'dark-theme' unless !@state.dark}",
      div
        id: 'loading'
      div
        id: 'loading2'
      div
        id: 'horizontal-center',
        div className: 'chat-container',
          div
            className: 'conversation'
            id: 'conv-scroll'
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
              intent: 'book-room  |  2pm  |  Marvin'
            React.createElement UserMessage,
              text: "1 hour"
              pic: @props.profile
            React.createElement BotMessage,
              text: "I've booked you Marvin for 1 hour at 2pm tomorrow!"
              pic: @props.chatbot
              intent: 'book-room  |  2pm  |  Marvin  |  1hour'
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
          div className: 'input',
            form
              id: 'chatbot'
              onSubmit: @handleSubmit
              input
                type: 'text'
                name: 'botquery'
                id: 'bot-query'
                placeholder: 'Type your message here'
                onChange: @handleChange
            div className: 'voice-input',
              img
                src: @props.mic
                alt: 'Voice'

module.exports = @Bot
