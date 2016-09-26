React = require 'react'

@Entity = React.createClass
  render: ->
    {div, h3, img} = React.DOM
    div className: 'entity-tile',
      h3 {}, @props.entity.entity
      for num, value of @props.entity.values
        React.createElement EntityValue,
          down: @props.down
          value: value
          key: num
      div className: 'add', '+ New Value'

module.exports = @Entity
