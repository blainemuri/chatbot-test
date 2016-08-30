React = require 'react'

@ChatStats = React.createClass
  render: ->
    {div, h2} = React.DOM
    div className: 'chat-stats',
      h2 {}, 'Stats'

module.exports = @ChatStats
