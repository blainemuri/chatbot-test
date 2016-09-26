React = require 'react'

@Intents = React.createClass
  render: ->
    {div, h3} = React.DOM
    console.log @props.intents
    div className: 'entity-container',
      div
        className: 'intent-tile'
        style: cursor: 'pointer'
        h3 {}, '+ New Intent'
      div className: 'intent-col-1',
        for num, intent of @props.intents
          if (num%2) == 0
            React.createElement Intent,
              key: num
              intent: intent
              down: @props.down
      div className: 'intent-col-2',
        for num, intent of @props.intents
          if (num%2) == 1
            React.createElement Intent,
              key: num
              intent: intent
              down: @props.down

module.exports = @Intents
