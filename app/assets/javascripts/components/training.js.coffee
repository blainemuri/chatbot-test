React = require 'react'

@Training = React.createClass
  getInitialState: ->
    show: 'newbot'
    content: {}
    id: 0

  showEntities: (e, id) ->
    data = JSON.parse @props.bots[id].trainingData
    @setState show: 'entities'
    @setState content: data
    @setState id: id

  showIntents: (e, id) ->
    data = JSON.parse @props.bots[id].trainingData
    @setState show: 'intents'
    @setState content: data
    @setState id: id
    # @setCurrentBot id

  showDialogue: (e, id) ->
    data = JSON.parse @props.bots[id].trainingData
    @setState show: 'dialogue'
    @setState content: data.dialog_nodes
    @setState id: id
    # @setCurrentBot id

  showNewBot: (e, id) ->
    @setState show: 'newbot'
    @setState id: id
    # @setCurrentBot id

  # setCurrentBot: (id) ->
  #   $.ajax
  #     method: 'POST'
  #     url: '/setBot'
  #     data: {'id': id}

  submitTrainingData: (json, id, type) ->
    $.ajax
      method: 'POST'
      url: '/setTrainingData'
      data: {'data': json, 'botId': id, type}

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
          React.createElement NewBot,
            id: @state.id
        else if @state.show == 'entities'
          React.createElement Entities,
            trainingData: @state.content
            down: @props.down
            submitTrainingData: @submitTrainingData
            id: @state.id
        else if @state.show == 'intents'
          React.createElement Intents,
            # intent: @state.content
            trainingData: @state.content
            down: @props.down
            submitTrainingData: @submitTrainingData
            id: @state.id
        else if @state.show == 'dialogue'
          React.createElement Dialogue,
            dialogue: @state.content
            id: @state.id

module.exports = @Training
