React = require 'react'

@ChatMenu = React.createClass
  getInitialState: ->
    active: 'bot'
    selected: no
    lightsOut: no

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

  render: ->
    {div, img, a, span, svg, g, path} = React.DOM
    div className: "main #{'dark' if @state.lightsOut}",
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
