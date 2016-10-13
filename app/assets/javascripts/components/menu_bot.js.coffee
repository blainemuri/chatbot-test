React = require 'react'

@MenuBot = React.createClass
  render: ->
    {div} = React.DOM
    div
      className: 'bot'
      key: @props.id
      div
        className: 'menu-option'
        onClick: (e) => @props.showNewBot e, @props.id, @props.bot.id
        @props.bot.name
      div
        className: 'menu-suboption'
        onClick: (e) => @props.showEntities e, @props.id, @props.bot.id
        'Entities'
      div
        className: 'menu-suboption'
        onClick: (e) => @props.showIntents e, @props.id, @props.bot.id
        'Intents'
      div
        className: 'menu-suboption'
        onClick: (e) => @props.showDialogue e, @props.id, @props.bot.id
        'Dialogue'

module.exports = @MenuBot
