React = require 'react'

@MenuBot = React.createClass
  render: ->
    {div} = React.DOM
    div
      className: 'bot'
      key: @props.id
      div
        className: 'menu-option'
        onClick: (e) => @props.showNewBot e, @props.id
        @props.bot.name
      div
        className: 'menu-suboption'
        onClick: (e) => @props.showEntities e, @props.id
        'Entities'
      div
        className: 'menu-suboption'
        onClick: (e) => @props.showIntents e, @props.id
        'Intents'
      div
        className: 'menu-suboption'
        onClick: (e) => @props.showDialogue e, @props.id
        'Dialogue'

module.exports = @MenuBot
