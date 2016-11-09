React = require 'react'

@Dashboard = React.createClass
  render: ->
    {div, img} = React.DOM
    div id: 'dashboard',
      img
        src: @props.overview

module.exports = @Dashboard
