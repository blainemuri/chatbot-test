React = require 'react'
# CableMixin = require('action-cable-react').CableMixin
# ChannelMixin = require('action-cable-react').ChannelMixin

@Bot = React.createClass
  getInitialState: ->
    text: ""
    dark: no
    messages: []
    url: ''

  handleSubmit: (e) ->
    e.preventDefault()

    text = @state.text
    @setState text: ''
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
                  'text': text
                }
              }
            }
      method: 'POST'
    .done (response) =>
      @forceUpdate()
    .fail ->
      alert 'Message failed to send!'

  handleChange: (e) -> @setState text: e.target.value

  toggleDark: -> @setState dark: !@state.dark

  componentWillUnmount: ->
    TweenMax.to('#horizontal-center', .05, {opacity: 0})

  componentWillMount: -> @setState messages: @props.conversation

  componentDidMount: ->
    chat = document.getElementById 'chat-container'
    chat.scrollTop = chat.scrollHeight
    message = document.getElementById 'message'
    tl = new TimelineMax()
    tl.add('start')
    tl.fromTo('#loading', .4, {scale: 1}, {scale: 2}, ease:Expo.easeInOut, 'start')
      .fromTo('#loading2', .3, {scale: .8}, {scale: 1.75}, ease:Expo.easeInOut, 'start')
      .to('#loading', .3, {scale: 1, opacity: 0}, 'start+.1')
      .to('#loading2', .4, {scale: .6, opacity: 0}, 'start+.1')
      # .to(chat, .5, {top: 0, opacity: 1}, 'start+.2')
      .staggerTo('.message', .2, {transform: "translateY(0)", opacity: 1}, 0, 'start+.2')
    tl.timeScale(1)

    # Set up the faye websocket client to listen to /bot
    client = new Faye.Client(window.location.protocol + "//" + window.location.host + "/faye")
    client.subscribe "/bot-#{@props.convId}", (data) =>
      messages = @state.messages
      messages.push data.message
      @setState messages: messages
      chat.scrollTop = chat.scrollHeight
      message = $('.message:last')
      tl = new TimelineMax()
      tl.add('start')
      tl.fromTo(message, .25, {zoom: '50%', opacity: 0, marginTop: 20}, {transform: "translateY(0)", opacity: 1, zoom: '100%', marginTop: 0}, 'start')
        .to(chat, .25, {scrollTop: chat.scrollHeight}, 'start')
      # TweenLite.fromTo(message, .4, {zoom: '50%', opacity: 0, marginTop: 20}, {transform: "translateY(0)", opacity: 1, zoom: '100%', marginTop: 0})

  render: ->
    {button, div, input, img, form, iframe} = React.DOM
    div className: "bot-chat-outer #{'dark-theme' unless !@state.dark}",
      div
        id: 'loading'
      div
        id: 'loading2'
      div
        id: 'horizontal-center'
        div id: 'chat-container',
          div
            className: 'conversation'
            id: 'conv-scroll'
            for comment, id in @state.messages
              last = (id == @state.messages.length-1 && comment.commentable_type == 'User')
              if comment.commentable_type == 'User'
                React.createElement UserMessage,
                  comment: comment
                  pic: @props.profile
                  key: id
                  loading: last
              else if comment.commentable_type == 'Bot'
                if comment.context?
                  if JSON.parse(comment.context).gif
                    React.createElement BotMessage,
                      pic: @props.chatbot
                      comment: comment
                      admin: no
                      key: id
                      animate: id
                      gif: yes
                      loading: no
                  else
                    React.createElement BotMessage,
                      pic: @props.chatbot
                      comment: comment
                      admin: no
                      key: id
                      animate: id
                      gif: no
                      loading: no
                else
                  React.createElement BotMessage,
                    pic: @props.chatbot
                    comment: comment
                    admin: no
                    key: id
                    animate: id
                    gif: no
                    loading: no
            # iframe
            #   src: @state.url
            #   height: "200"
            #   frameBorder: "0"
            #   className: "giphy-embed"
            #   allowFullScreen: false
      div
        id: 'bottom-input',
        div className: 'input',
          form
            id: 'chatbot'
            type: 'submit'
            onSubmit: @handleSubmit
            input
              type: 'text'
              name: 'botquery'
              id: 'bot-query'
              className: "#{'send' if @state.text != ''}"
              placeholder: 'Message...'
              onChange: @handleChange
              value: @state.text
            button
              type: 'submit'
              className: "#{'send' if @state.text != ''}"
              'Send'

module.exports = @Bot
