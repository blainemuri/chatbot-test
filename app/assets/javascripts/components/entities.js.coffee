React = require 'react'

@Entities = React.createClass
  # setEntity: (entity) ->
  #   $.ajax(
  #     method: 'POST'
  #     url: '/newEntity'
  #   )

  render: ->
    {div, h3} = React.DOM
    div className: 'entity-container',
      for num, entity of @props.entities
        React.createElement Entity,
          key: num
          entity: entity
          down: @props.down
      div
        className: 'entity-tile'
        style: cursor: 'pointer'
        h3 {}, '+ New Entity'

module.exports = @Entities
