React = require 'react'

@EntityValue = React.createClass
  getInitialState: ->
    showSynonyms: no

  showSynonyms: -> @setState showSynonyms: !@state.showSynonyms

  render: ->
    {div, img} = React.DOM
    div className: 'values',
      div
        className: 'value'
        @props.value.value
      img
        src: @props.down
        className: 'down'
        alt: '+'
        onClick: @showSynonyms
      if @state.showSynonyms
        div className: 'synonym-container',
          if @props.value.synonyms?
            for syn, num in @props.value.synonyms
              div
                className: 'synonym'
                key: num
                syn
          div className: 'add synonym', '+ Add Synonym'

module.exports = @EntityValue
