React = require 'react'

@AdminMenu = React.createClass
  getInitialState: ->
    logo: no
    page: 'Chatbots'

  setOption: (page) ->
    if page == 'Overview'
      @setState logo: yes
    else
      @setState logo: no
    @setState page: page

  render: ->
    {div, h1, img} = React.DOM
    div id: 'admin',
      div className: 'nav',
        div className: 'title',
          if @state.logo
            React.createElement Logo, null
          else
            h1 {}, @state.page
        div className: 'portal',
          div
            className: 'option'
            onClick: (e) => @setOption 'Overview'
            'Overview'
          div
            className: 'option'
            onClick: (e) => @setOption 'Exosphere'
            'Exosphere'
          div
            className: 'option'
            onClick: (e) => @setOption 'XMS'
            'XMS'
          div
            className: 'option'
            onClick: (e) => @setOption 'Chatbots'
            'Chatbots'
          div className: 'user',
            img
              src: @props.profile
              alt: ''
            div className: 'user-info',
              div className: 'name', 'Brian Beckman'
              div className: 'email', 'brian.beckman@originate.com'
            React.createElement Down, null
      div className: 'main',
        if @state.page == 'Overview'
          React.createElement Overview,
            setPage: @setOption
            home1: @props.home1
            home2: @props.home2
            home3: @props.home3
        else if @state.page == 'Exosphere'
          React.createElement Exosphere, null
        else if @state.page == 'XMS'
          React.createElement XMS, null
        else if @state.page == 'Chatbots'
          React.createElement Botler,
            down: @props.down
            chatbot: @props.chatbot
            profile: @props.profile
            bots: @props.bots
            convs: @props.convs
            overview: @props.overview
            dialogue: @props.dialogue

module.exports = @AdminMenu
#
# getInitialState: ->
#   active: 'training'
#   selected: no
#
# setActive: (e, link) ->
#   e.preventDefault()
#   @setState active: link
#
# goToLogin: -> window.location.href = '../'
#
# render404: -> window.location.href = '../404'
#
# setSelected: -> @setState selected: !@state.selected
#
# loadChatbot: ->
#   baseURL = window.location.host
#   url = 'http://' + baseURL + '/bot'
#   win = window.open(url, '_blank')
#   win.focus()
#   # var win = window.open(url, '_blank');
#   # win.focus();
#
# handleSubmit: (e) ->
#   e.preventDefault()
#   file = document.getElementById 'bot-json-file'
#   console.log file.target
#
# render: ->
#   {div, img, a, span, svg, g, path, form, input} = React.DOM
#   div className: 'admin-container',
#     div
#       id: 'chat-menu'
#       div className: "profile #{'selected' if @state.selected}",
#         div
#           className: "profile-options #{'selected' if @state.selected}"
#           onClick: @setSelected
#           img
#             src: @props.profile
#             alt: 'User'
#           div className: 'right',
#             svg
#               version: "1.1"
#               xmlns: "http://www.w3.org/2000/svg"
#               xmlns:xlink: "http://www.w3.org/1999/xlink"
#               x: "0px"
#               y: "0px"
#               viewBox: "0 0 1000 1000"
#               enableBackground: "new 0 0 1000 1000"
#               id: 'down-arrow'
#               className: "#{'selected' if @state.selected}"
#               g
#                 path
#                   d: "M887.2,209.2L499.7,589.1L112.8,209.7L10,310.5l489.7,480.3L990,310L887.2,209.2z"
#             span className: "#{'selected' if @state.selected}", 'Username'
#         a
#           className: "option #{'selected-1' if @state.selected}"
#           'Profile'
#         a
#           className: "option #{'selected-2' if @state.selected}"
#           'Settings'
#         a
#           className: "option #{'selected-3' if @state.selected}"
#           onClick: @loadChatbot
#           'Chatbot'
#         a
#           className: "option #{'selected-4' if @state.selected}"
#           href: '../'
#           'Sign Out'
#       div className: 'admin-options',
#         a
#           className: "chat-btn #{'active' if @state.active == 'stats'}"
#           onClick: (e) => @setActive e, 'stats'
#           # href: '../chatbot/stats'
#           'Stats'
#         a
#           className: "chat-btn #{'active' if @state.active == 'log'}"
#           onClick: (e) => @setActive e, 'log'
#           # href: '../chatbot/history'
#           'Chat Log'
#         a
#           className: "chat-btn #{'active' if @state.active == 'training'}"
#           onClick: (e) => @setActive e, 'training'
#           'Training'
#       div className: 'chat-header', 'Botler'
#     if @state.active == 'log'
#       React.createElement ChatLog,
#         chatbot: @props.chatbot
#         profile: @props.profile
#         bots: @props.bots
#         convs: @props.convs
#         down: @props.down
#     else if @state.active == 'stats'
#       React.createElement ChatStats,
#         bots: @props.bots
#         convs: @props.convs
#         down: @props.down
#     else if @state.active == 'training'
#       React.createElement Training,
#         bots: @props.bots
#         down: @props.down
