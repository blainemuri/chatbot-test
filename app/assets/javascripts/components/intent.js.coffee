React = require 'react'

@Intent = React.createClass
  getInitialState: ->
    example: ""

  createNewExample: (e) ->
    e.stopPropagation()
    e.preventDefault()

    @props.createNewExample(@props.intent, @state.example, @props.id)
    @setState example: ""

  handleOnChange: (e) -> @setState example: e.target.value

  render: ->
    {div, h3, input, form} = React.DOM
    div className: 'intent-tile',
      h3 {}, @props.intent.intent
      for id, example of @props.intent.examples
        div
          className: 'example'
          key: id
          example.text
      form
        onSubmit: @createNewExample
        input
          placeholder: '+ New Example'
          type: 'text'
          value: @state.value
          onChange: @handleOnChange

module.exports = @Intent
