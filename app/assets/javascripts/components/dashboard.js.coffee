React = require 'react'

@Dashboard = React.createClass
  render: ->
    {div} = React.DOM
    div {}, 'Dashboard!'

module.exports = @Dashboard
