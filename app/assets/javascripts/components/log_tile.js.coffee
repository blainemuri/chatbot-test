React = require 'react'

@LogTile = React.createClass
  render: ->
    {a, div, h5, h6, img, p, span} = React.DOM
    div
      className: 'log-tile'
      onClick: @props.open
      div className: 'header-left',
        div className: 'username', 'Username'
        span {}, 'Jun 18, 2016'
      div className: 'header-right',
        img
          src: @props.profile
          alt: 'User'
      p {}, 'This is the description of the conversation or something like that'

module.exports = @LogTile
