React = require 'react'

@Intents = React.createClass
  getInitialState: ->
    intent: ""

  handleOnChange: (e) ->
    @setState intent: e.target.value

  getLastKey: (arr) ->
    num = parseInt(Object.keys(arr).sort().reverse()[0])
    if isNaN(num) then -1 else num

  createNewIntent: (e) ->
    e.stopPropagation()
    e.preventDefault()

    data = @props.trainingData
    lastKey = @getLastKey(data.intents) + 1
    data.intents[lastKey] = {'intent': @state.intent, 'examples': [], 'description': null}
    data = JSON.stringify(data)
    @props.submitTrainingData data, @props.id, {'intent': @state.intent}
    @setState intent: ""

  createNewExample: (intent, example, id) ->
    data = @props.trainingData
    lastKey = @getLastKey(intent.examples) + 1
    newIntent = intent

    newIntent.examples[lastKey] = {'text': example}
    data.intents[id] = newIntent

    @props.submitTrainingData JSON.stringify(data), @props.id, {'example', example}

    # console.log JSON.stringify(@props.trainingData)

  render: ->
    {div, input, form, h3} = React.DOM
    div className: 'entity-container',
      div className: 'intent-col',
        for num, intent of @props.trainingData.intents
          React.createElement Intent,
            key: num
            id: num
            intent: intent
            createNewExample: @createNewExample
        div
          className: 'intent-tile'
          style: cursor: 'pointer'
          h3 {}, 'Create New Intent'
          form
            onSubmit: @createNewIntent
            input
              placeholder: '+ New Intent'
              type: 'text'
              value: @state.intent
              onChange: @handleOnChange

module.exports = @Intents
