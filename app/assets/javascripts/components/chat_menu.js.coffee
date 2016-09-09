React = require 'react'

@ChatMenu = React.createClass
  getInitialState: ->
    active: 'bot'
    selected: no

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

  render: ->
    {div, img, a, span, svg, g, path} = React.DOM
    div {},
      div
        id: 'chat-menu'
        div className: 'blur', ''
        div className: 'time', 'Yesterday'
        div className: "profile #{'selected' if @state.selected}",
          div
            className: "profile-options #{'selected' if @state.selected}"
            onClick: @setSelected
            img
              src: @props.profile
              alt: 'User'
            div className: 'right',
              svg
                version: "1.1"
                xmlns: "http://www.w3.org/2000/svg"
                xmlns:xlink: "http://www.w3.org/1999/xlink"
                x: "0px"
                y: "0px"
                viewBox: "0 0 1000 1000"
                enableBackground: "new 0 0 1000 1000"
                id: 'down-arrow'
                className: "#{'selected' if @state.selected}"
                g
                  path
                    d: "M887.2,209.2L499.7,589.1L112.8,209.7L10,310.5l489.7,480.3L990,310L887.2,209.2z"
              span className: "#{'selected' if @state.selected}", 'Username'
          a
            className: "option #{'selected-1' if @state.selected}"
            'Profile'
          a
            className: "option #{'selected-2' if @state.selected}"
            'Settings'
          a
            className: "option #{'selected-3' if @state.selected}"
            onClick: @loadAdminSettings
            'Admin'
          a
            className: "option #{'selected-4' if @state.selected}"
            href: '../'
            'Sign Out'
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
        div className: 'chat-header', 'Botler'
      React.createElement Bot,
        chatbot: @props.chatbot
        profile: @props.profile
        mic: @props.mic
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
