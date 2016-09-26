React = require 'react'

@Entities = React.createClass
  getInitialState: ->
    entity: ""

  handleOnChange: (e) -> @setState entity: e.target.value

  createNewEntity: (e) ->
    e.stopPropagation()
    e.preventDefault()

    data = @props.trainingData
    lastKey = parseInt(Object.keys(data.entities).sort().reverse()[0]) + 1
    data.entities[lastKey] = {'entity': @state.entity, 'values': [], 'open_list': false, 'description': null}
    console.log JSON.stringify(data)

  render: ->
    {div, input, form} = React.DOM
    div className: 'entity-container',
      for num, entity of @props.trainingData.entities
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
