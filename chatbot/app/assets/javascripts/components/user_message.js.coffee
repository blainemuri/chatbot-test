React = require 'react'

@UserMessage = React.createClass
  render: ->
    {div, img, p, h3, span} = React.DOM
    div className: 'user-message',
      img
        src: @props.pic
        alt: 'Botler'
      div className: 'message',
        div className: 'heading',
          h3 {}, 'User'
          span {}, '10:33pm'
        p {}, @props.text

module.exports = @UserMessage
