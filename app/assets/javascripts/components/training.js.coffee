React = require 'react'

@Training = React.createClass
  getInitialState: ->
    show: 'newbot'
    content: {}
    id: 1

  showEntities: (e, id, botId) ->
    data = JSON.parse @props.bots[id].trainingData
    @setState show: 'entities'
    @setState content: data
    @setState id: botId

  showIntents: (e, id, botId) ->
    data = JSON.parse @props.bots[id].trainingData
    @setState show: 'intents'
    @setState content: data
    @setState id: botId
    # @setCurrentBot id

  showDialogue: (e, id, botId) ->
    data = JSON.parse @props.bots[id].trainingData
    @setState show: 'dialogue'
    @setState content: data.dialog_nodes
    @setState id: botId
    # @setCurrentBot id

  showNewBot: (e, id, botId) ->
    @setState show: 'newbot'
    @setState id: botId
    # @setCurrentBot id

  # setCurrentBot: (id) ->
  #   $.ajax
  #     method: 'POST'
  #     url: '/setBot'
  #     data: {'id': id}

  submitTrainingData: (json, id, type) ->
    console.log id
    $.ajax
      method: 'POST'
      url: '/setTrainingData'
      data: {'data': json, 'botId': id, type}

  # TODO: Make it so that newbot spits out the correct bot id
  #       For now it's just the first id
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
