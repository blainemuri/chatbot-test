React = require 'react'

@Training = React.createClass
  getInitialState: ->
    show: 'newbot'
    content: {}

  showEntities: (data, e) ->
    data = JSON.parse data
    @setState show: 'entities'
    @setState content: data

  showIntents: (data, e) ->
    data = JSON.parse data
    @setState show: 'intents'
    @setState content: data.intents

  showDialogue: (data, e) ->
    data = JSON.parse data
    @setState show: 'dialogue'
    @setState content: data.dialog_nodes

  showNewBot: -> @setState show: 'newbot'

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
          div
            className: 'bot'
            key: id
            div
              className: 'menu-option'
              onClick: @showNewBot
              bot.name
            div
              className: 'menu-suboption'
              onClick: (e) => @showEntities @props.bots[id-1].trainingData, e
              'Entities'
            div
              className: 'menu-suboption'
              onClick: (e) => @showIntents @props.bots[id-1].trainingData, e
              'Intents'
            div
              className: 'menu-suboption'
              onClick: (e) => @showDialogue @props.bots[id-1].trainingData, e
              'Dialogue'
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
