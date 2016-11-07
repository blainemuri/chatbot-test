React = require 'react'

@Botler = React.createClass
  render: ->
    {div} = React.DOM
    div id: 'botler',
      div className: 'left-nav',
        div className: 'inner-nav',
          div className: 'heading', 'Dashboard'
          div className: 'heading', 'Training'
          div className: 'heading', 'Chat Log'
          div className: 'heading', 'Stats'
          div className: 'line', ''
          React.createElement BotMenu,
            title: 'Originate'
            down: @props.down
          React.createElement BotMenu,
            title: 'Originate-adminbot'
            down: @props.down

module.exports = @Botler
