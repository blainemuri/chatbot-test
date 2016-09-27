React = require 'react'

@Entity = React.createClass
  getInitialState: ->
    value: ""

  createNewValue: (e) ->
    e.stopPropagation()
    e.preventDefault()

    @props.createNewValue(@props.entity, @state.value, @props.id)
    @setState value: ""


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
      form
        onSubmit: @createNewValue
        input
          placeholder: '+ New Value'
          type: 'text'
          value: @state.value
          onChange: @handleOnChange

module.exports = @Entity
