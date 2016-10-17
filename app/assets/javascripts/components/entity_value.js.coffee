React = require 'react'

@EntityValue = React.createClass
  getInitialState: ->
    showSynonyms: no
    synonym: ""

  showSynonyms: -> @setState showSynonyms: !@state.showSynonyms

  createNewSynonym: (e) ->
    e.stopPropagation()
    e.preventDefault()

    @props.createNewSynonym(@props.value, @state.value)
    @setState synonym: ""

  # handleOnChange: (e) -> @setState synonym: e.target.value

  findSynonyms: (data) ->
    # url = 'http://words.bighugelabs.com/api/2/2b4a03c1c33c6474e11628586fe8b016/'
    # word = JSON.stringify(data['value']['value']).split(/"/)[1]
    # url += word
    # url += '/'
    # console.log url
    # $.ajax 
    #   url: url,
    #   method: 'POST',
    # .done (response) =>
    #   console.log response
    # .fail ->
    #   console.log 'No synonyms found'


  render: ->
    {div, img, input, form} = React.DOM
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
              React.createFactory(SynonymValue)
                key: num
                syn: syn
          form
            onSubmit: @createNewSynonym
            input
              placeholder: '+ New Synonym'
              type: 'text'
              value: @state.value
              onChange: @handleOnChange

module.exports = @EntityValue
