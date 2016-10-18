React = require 'react'

@BotOption = React.createClass
  render: ->
    {div, img} = React.DOM
    div
      className: 'inner-sort'
      onClick: (e) => @props.setOption(@props.id, e)
      div className: 'type', @props.name
      if @props.img?
        img
          className: 'arrow'
          src: @props.down
          alt: ''

module.exports = @BotOption
