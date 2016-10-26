React = require 'react'

@Bot = React.createClass
  getInitialState: ->
    text: ""
    dark: no

  handleSubmit: (e) ->
    e.preventDefault()
    last =  @props.conversation[..].pop()
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
    .fail ->
      alert 'Error sending message!'
    @setState text: ''

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
      .staggerTo('.message', .2, {transform: "translateY(0)", opacity: 1}, 0, 'start+.2')
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
            for comment, id in @props.conversation
              if comment.commentable_type == 'User'
                React.createElement UserMessage,
                  text: comment.body
                  pic: @props.profile
                  id: id
                  key: id
              else if comment.commentable_type == 'Bot'
                React.createElement BotMessage,
                  text: comment.body
                  pic: @props.chatbot
                  id: comment.id
                  conversationId: comment.conversation_id
                  correct: comment.correct
                  admin: no
                  key: id
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
