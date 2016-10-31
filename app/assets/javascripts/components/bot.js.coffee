React = require 'react'
# CableMixin = require('action-cable-react').CableMixin
# ChannelMixin = require('action-cable-react').ChannelMixin

@Bot = React.createClass
  getInitialState: ->
    text: ""
    dark: no
    messages: []

  handleSubmit: (e) ->
    e.preventDefault()

    last =  @state.messages[..].pop()
    context = {}
    if last?
      if last.commentable_type == "Bot"
        context = JSON.parse(last.context).context
    $.ajax
      url: '/bot'
      data: {
              'query': {
                'input': {
                  'text': @state.text
                },
                'context': context
              }
            }
      method: 'POST'
    .done (response) =>
      @setState text: ""
      @forceUpdate()
    .fail ->
      alert 'Error sending message!'
    @setState text: ''

  handleChange: (e) -> @setState text: e.target.value

  toggleDark: -> @setState dark: !@state.dark

  componentWillUnmount: ->
    TweenMax.to('#horizontal-center', .05, {opacity: 0})

  componentWillMount: ->
    @setState messages: @props.conversation

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
      .staggerTo('.message', .2, {transform: "translateY(0)", opacity: 1}, 0, 'start+.2')
    tl.timeScale(1)

    # Set up the faye websocket client to listen to /bot
    client = new Faye.Client(window.location.protocol + "//" + window.location.host + "/faye")
    client.subscribe '/bot', (data) =>
      messages = @state.messages
      messages.push data.message
      @setState messages: messages
      conversation.scrollTop = conversation.scrollHeight
      TweenLite.to('.message', .4, {transform: "translateY(0)", opacity: 1})

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
            for comment, id in @state.messages
              if comment.commentable_type == 'User'
                React.createElement UserMessage,
                  comment: comment
                  pic: @props.profile
                  key: id
              else if comment.commentable_type == 'Bot'
                React.createElement BotMessage,
                  pic: @props.chatbot
                  comment: comment
                  admin: no
                  key: id
                  animate: id
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
                value: @state.text
            div className: 'voice-input',
              img
                src: @props.mic
                alt: 'Voice'

module.exports = @Bot
