React = require 'react'

@Intent = React.createClass
  render: ->
    {div, h3} = React.DOM
    div className: 'intent-tile',
      h3 {}, @props.intent.intent
      for id, example of @props.intent.examples
        console.log id
        div
          className: 'example'
          key: id
          example.text
      div className: 'example add', '+ Add Example'

module.exports = @Intent
