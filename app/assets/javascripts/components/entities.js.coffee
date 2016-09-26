React = require 'react'

@Entities = React.createClass
  getInitialState: ->
    entity: ""

  handleOnChange: (e) -> @setState entity: e.target.value

  createNewEntity: (e) ->
    e.preventDefault()
    e.stopPropagation()

    $.ajax
      method: 'POST'
      url: '/newEntity'
      data: {'entity': @state.entity}

  render: ->
    {div, input, form} = React.DOM
    div className: 'entity-container',
      for num, entity of @props.entities
        React.createElement Entity,
          key: num
          entity: entity
          down: @props.down
      div
        className: 'entity-tile'
        style: cursor: 'pointer'
        form 
          onSubmit: @createNewEntity
          input
            placeholder: '+ New Entity'
            type: 'text'
            onChange: @handleOnChange


module.exports = @Entities
