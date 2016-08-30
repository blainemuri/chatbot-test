React = require 'react'

@BotMessage = React.createClass
  render: ->
    {div, img, p, h3, span} = React.DOM
    div className: 'bot-message',
      img
        src: @props.pic
        alt: 'Botler'
      div
        className: 'message'
        id: 'message'
        div className: 'heading',
          h3 {}, 'Botler'
          span {}, '10:33pm'
        p {}, @props.text

module.exports = @BotMessage
