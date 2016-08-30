React = require 'react'

@LogTile = React.createClass
  render: ->
    {a, div, h3, h4, img, p} = React.DOM
    div
      className: 'log-tile'
      onClick: @props.open
      div className: 'header-left',
        h3 {}, 'Username'
        h4 {}, 'Jun 18, 2016'
      div className: 'header-right',
        img
          src: @props.profile
          alt: 'User'
      p {}, 'This is the description of the conversation or something like that'

module.exports = @LogTile
