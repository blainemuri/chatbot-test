React = require 'react'

@Entity = React.createClass
  getInitialState: ->
    value: ""

  getLastKey: (arr) ->
    num = parseInt(Object.keys(arr).sort().reverse()[0])
    if isNaN(num) then -1 else num

  createNewValue: (e) ->
    e.stopPropagation()
    e.preventDefault()

    @props.createNewValue(@props.entity, @state.value, @props.id)
    @setState value: ""

  createNewSynonym: (value, synonym)->
    @props.createNewSynonym value, synonym, @props.id

  handleOnChange: (e) -> @setState value: e.target.value

  render: ->
    {div, h3, img, input, form} = React.DOM
    div className: 'entity-tile',
      h3 {}, @props.entity.entity
      for num, value of @props.entity.values
        React.createElement EntityValue,
          down: @props.down
          value: value
          key: num
          createNewSynonym: @createNewSynonym
      form
        onSubmit: @createNewValue
        input
          placeholder: '+ New Value'
          type: 'text'
          value: @state.value
          onChange: @handleOnChange

module.exports = @Entity
