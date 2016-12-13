React = require 'react'

@ChatMenu = React.createClass
  getInitialState: ->
    active: 'bot'
    selected: no
    lightsOut: no
    showMenu: no

  setActive: (e, link) ->
    e.preventDefault()
    @setState active: link

  goToLogin: -> window.location.href = '../'

  render404: -> window.location.href = '../404'

  setSelected: -> @setState selected: !@state.selected

  loadAdminSettings: ->
    baseURL = window.location.host
    url = 'http://' + baseURL + '/admin'
    win = window.open(url, '_blank')
    win.focus()
    # var win = window.open(url, '_blank');
    # win.focus();

  componentDidMount: ->
    client = new Faye.Client(window.location.protocol + "//" + window.location.host + "/faye")
    client.subscribe '/lights', (data) =>
      @setState lightsOut: data.lightsOut

  toggleMenu: -> @setState showMenu: !@state.showMenu

  render: ->
    {div, img, a, span, svg, g, path, textarea, form, button, input} = React.DOM
    div className: "main #{'dark' if @state.lightsOut} #{'show-menu' if @state.showMenu}",
      div
        id: 'chat-menu'
        # a
        #   className: 'chat-btn 1'
        #   onClick: (e) => @setActive e, 'login'
        #   # href: '../chatbot'
        #   'Sign Out'
        # a
        #   className: 'chat-btn 2'
        #   onClick: (e) => @setActive e, 'stats'
        #   # href: '../chatbot/stats'
        #   'Stats'
        # a
        #   className: 'chat-btn 3'
        #   onClick: (e) => @setActive e, 'history'
        #   # href: '../chatbot/history'
        #   'Chat Log'
        # a
        #   className: 'chat-btn 3'
        #   onClick: (e) => @setActive e, 'bot'
        #   # href: '../chatbot/bot'
        #   'New Chat'
        # div className: 'chat-logo',
        #   # img
        #   #   className: 'chat-botler'
        #   #   src: @props.chatbot
        div className: 'chat-header',
          React.createElement Butler, null
          div
            className: 'more'
            onClick: @toggleMenu
            'i'
      div
        id: 'right-menu'
        className: "#{'show' if @state.showMenu}"
        div
          className: 'close'
          onClick: @toggleMenu
          'x'
        React.createElement Butler, null
        div className: 'analytics',
          div className: 'title', 'Audience Analysis'
          div className: 'analytic',
            span {}, 'New sessions'
            div {}, @props.numConvs
          div className: 'analytic',
            span {}, 'Questions answered'
            div {}, @props.answered
          div className: 'analytic',
            span {}, 'Bounce rate'
            div {}, '14%'
          div className: 'analytic',
            span {}, 'Mobile'
            div {}, '67%'
          div className: 'analytic',
            span {}, 'Desktop'
            div {}, '33%'
          form
            className: 'user-feedback'
            name: 'feedback'
            div className: 'title', 'Give us your ideas and help us improve!'
            textarea
              placeholder: ''
            button className: 'bot-submit', 'Send'
          # form
          #   className: 'user-email'
          #   name: 'email'
          #   input
          #     placeholder: 'Sign up for updates...'
          #   button className: 'bot-submit', 'Send'
      React.createElement Bot,
        chatbot: @props.chatbot
        profile: @props.profile
        mic: @props.mic
        conversation: @props.conversation
      # if @state.active == 'bot'
      #   React.createElement Bot,
      #     chatbot: @props.chatbot
      #     profile: @props.profile
      # else if @state.active == 'history'
      #   React.createElement ChatLog,
      #     chatbot: @props.chatbot
      #     profile: @props.profile
      # else if @state.active == 'stats'
      #   React.createElement ChatStats, null
      # else if @state.active == 'login'
      #   @goToLogin()
      # else
      #   @render404()

module.exports = @ChatMenu
