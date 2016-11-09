React = require 'react'

@Dialogue = React.createClass
  render: ->
    {div, img} = React.DOM
    div id: 'dialogue',
      img
        src: @props.dialogue

module.exports = @Dialogue
