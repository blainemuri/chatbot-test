React = require 'react'

@BotMenu = React.createClass
  getInitialState: ->
    showOptions: no

  showOptions: -> @setState showOptions: !@state.showOptions

  render: ->
    {div, img} = React.DOM
    div className: 'bot',
      div
        className: 'title-wrapper'
        onClick: @showOptions
        div className: 'title', @props.title
        React.createElement Down, null
      div className: "options #{'show' if @state.showOptions}",
        div
          className: 'option'
          onClick: (e) => @props.showNewBot e, @props.id, @props.bot.id
          'New'
        div
          className: 'option'
          onClick: (e) => @props.showEntities e, @props.id, @props.bot.id
          'Entities'
        div
          className: 'option'
          onClick: (e) => @props.showIntents e, @props.id, @props.id
          'Intents'
        div
          className: 'option'
          onClick: (e) => @props.showDialogue e, @props.id, @props.bot.id
          'Dialogue'

module.exports = @BotMenu
