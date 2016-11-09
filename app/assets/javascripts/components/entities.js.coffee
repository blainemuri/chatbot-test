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

  createNewSynonym: (value, synonym, id)->
    data = @props.trainingData
    lastKey = @getLastKey(value.synonyms) + 1
    newValue = value
    newValue.synonyms[lastKey] = synonym
    data.entities[id].value = newValue

    @props.submitTrainingData JSON.stringify(data), @props.id, {'synonyms': synonym}

  render: ->
    {div, input, form, h3} = React.DOM
    div className: 'entity-container',
      for num, entity of @props.trainingData.entities
        React.createElement Entity,
          key: num
          id: num
          entity: entity
          createNewValue: @createNewValue
          createNewSynonym: @createNewSynonym
      div
        className: 'entity-tile'
        style: cursor: 'pointer'
        h3 {}, 'Create New Entity'
        form
          onSubmit: @createNewEntity
          input
            placeholder: '+ New Entity'
            type: 'text'
            value: @state.entity
            onChange: @handleOnChange


module.exports = @Entities
