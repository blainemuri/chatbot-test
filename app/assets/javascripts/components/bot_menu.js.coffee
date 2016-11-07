React = require 'react'

@BotMenu = React.createClass
  getInitialState: ->
    showOptions: no

  showOptions: -> @setState showOptions: !@state.showOptions

  render: ->
    {div, img} = React.DOM
    div className: 'bot',
      div className: 'title-wrapper',
        div
          className: 'title'
          onClick: @showOptions
          @props.title
        img
          src: @props.down
          alt: ''
      div className: "options #{'show' if @state.showOptions}",
        div className: 'entities', 'Entities'
        div className: 'Intents', 'Intents'
        div className: 'Dialogue', 'Dialogue'

module.exports = @BotMenu
