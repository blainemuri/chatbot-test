React = require 'react'

@Training = React.createClass
  getInitialState: ->
    show: 'newbot'
    content: {}

  showEntities: (e, id) ->
    data = JSON.parse @props.bots[id].trainingData
    @setState show: 'entities'
    @setState content: data

  showIntents: (e, id) ->
    data = JSON.parse @props.bots[id].trainingData
    @setState show: 'intents'
    @setState content: data.intents
    # @setCurrentBot id

  showDialogue: (e, id) ->
    data = JSON.parse @props.bots[id].trainingData
    @setState show: 'dialogue'
    @setState content: data.dialog_nodes
    # @setCurrentBot id

  showNewBot: (e, id) ->
    @setState show: 'newbot'
    # @setCurrentBot id

  setCurrentBot: (id) ->
    $.ajax
      method: 'POST'
      url: '/setBot'
      data: {'id': id}

  submitTrainingData: (json) ->
    $.ajax
      method: 'POST'
      url: '/setTrainingData'
      data: {'data': json}

  render: ->
    {div, input} = React.DOM
    div className: 'training-container',
      div className: 'left-menu',
        for bot, id in @props.bots
          React.createElement MenuBot,
            bot: bot
            id: id
            key: id
            showEntities: @showEntities
            showIntents: @showIntents
            showDialogue: @showDialogue
            showNewBot: @showNewBot
      div className: 'context',
        if @state.show == 'newbot'
          React.createElement NewBot, null
        else if @state.show == 'entities'
          React.createElement Entities,
            trainingData: @state.content
            down: @props.down
            submitTrainingData: @submitTrainingData
        else if @state.show == 'intents'
          React.createElement Intents, intents: @state.content
        else if @state.show == 'dialogue'
          React.createElement Dialogue, dialogue: @state.content

module.exports = @Training
