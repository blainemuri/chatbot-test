React = require 'react'

@AdminMenu = React.createClass
  getInitialState: ->
    active: 'log'
    selected: no

  setActive: (e, link) ->
    e.preventDefault()
    @setState active: link

  goToLogin: -> window.location.href = '../'

  render404: -> window.location.href = '../404'

  setSelected: -> @setState selected: !@state.selected

  loadChatbot: ->
    baseURL = window.location.host
    url = 'http://' + baseURL + '/bot'
    win = window.open(url, '_blank')
    win.focus()
    # var win = window.open(url, '_blank');
    # win.focus();

  handleSubmit: (e) ->
    e.preventDefault()
    file = document.getElementById 'bot-json-file'
    console.log file.target

  handleChange: (e) ->
    file = e.target.value
    reader = new FileReader()
    reader.onload = @onReaderLoad
    reader.readAsText e.target.files[0]

  onReaderLoad: (e) ->
    obj = JSON.parse(e.target.result)

    # Send the data to the backend
    $.ajax
      url: '/admin'
      data: obj
      method: 'POST'
    .done (response) =>
      alert 'Successfully saved new bot info'
    .fail ->
      alert 'Error uploading json file'

  render: ->
    {div, img, a, span, svg, g, path, form, input} = React.DOM
    div {},
      div
        id: 'chat-menu'
        div className: 'blur', ''
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
            onClick: @loadChatbot
            'Chatbot'
          a
            className: "option #{'selected-4' if @state.selected}"
            href: '../'
            'Sign Out'
        div className: 'admin-options',
          a
            className: "chat-btn #{'active' if @state.active == 'stats'}"
            onClick: (e) => @setActive e, 'stats'
            # href: '../chatbot/stats'
            'Stats'
          a
            className: "chat-btn #{'active' if @state.active == 'log'}"
            onClick: (e) => @setActive e, 'log'
            # href: '../chatbot/history'
            'Chat Log'
          input
            className: 'chat-btn'
            type: 'file'
            name: 'botjson'
            id: 'bot-json-file'
            onChange: @handleChange
        div className: 'chat-header', 'Botler'
      React.createElement ChatLog,
        chatbot: @props.chatbot
        profile: @props.profile

module.exports = @AdminMenu
