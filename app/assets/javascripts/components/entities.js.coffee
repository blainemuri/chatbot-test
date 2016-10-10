React = require 'react'

@Entities = React.createClass
  getInitialState: ->
    entity: ""

  handleOnChange: (e) -> @setState entity: e.target.value

  getLastKey: (arr) -> 
    num = parseInt(Object.keys(arr).sort().reverse()[0])
    if isNaN(num) then -1 else num

  createNewEntity: (e) ->
    e.stopPropagation()
    e.preventDefault()

    data = @props.trainingData
    lastKey = @getLastKey(data.entities) + 1
    data.entities[lastKey] = {'entity': @state.entity, 'values': [], 'open_list': false, 'description': null}
    data =  JSON.stringify(data)
    @props.submitTrainingData data, @props.id, {'entity': @state.entity}
    @setState entity: ""

  # value is going to be an object that needs to be appended to the values array
  createNewValue: (entity, value, id) ->
    data = @props.trainingData
    lastKey = @getLastKey(entity.values) + 1
    newEntity = entity
    newEntity.values[lastKey] = {'value': value, 'metadata': null, 'synonyms': []}
    data.entities[id] = newEntity

    @props.submitTrainingData JSON.stringify(data), @props.id, {'value': value}

  render: ->
    {div, input, form} = React.DOM
    div className: 'entity-container',
      # console.log JSON.stringify(@props.trainingData)
      for num, entity of @props.trainingData.entities
        React.createElement Entity,
          key: num
          id: num
          entity: entity
          down: @props.down
          createNewValue: @createNewValue
      div
        className: 'entity-tile'
        style: cursor: 'pointer'
        form
          onSubmit: @createNewEntity
          input
            placeholder: '+ New Entity'
            type: 'text'
            value: @state.entity
            onChange: @handleOnChange


module.exports = @Entities
