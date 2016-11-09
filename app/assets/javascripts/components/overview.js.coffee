React = require 'react'

@Overview = React.createClass
  render: ->
    {div, img} = React.DOM
    div id: 'overview',
      div className: 'tile-container',
        div className: 'tile',
          div className: 'title', 'Exosphere'
          div className: 'overview',
            img
              src: @props.home1
        div className: 'tile',
          div className: 'title', 'XMS'
          div className: 'overview',
            img
              src: @props.home2
        div
          className: 'tile'
          onClick: (e) => @props.setPage 'Chatbots'
          div className: 'title', 'Chatbots'
          div className: 'overview',
            img
              src: @props.home3

module.exports = @Overview
