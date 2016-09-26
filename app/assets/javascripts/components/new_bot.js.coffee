React = require 'react'

@NewBot = React.createClass
  handleChange: (e) ->
    file = e.target.value
    reader = new FileReader()
    reader.onload = @onReaderLoad
    reader.readAsText e.target.files[0]

  onReaderLoad: (e) ->
    obj = e.target.result
    # Send the data to the backend
    $.ajax
      url: '/admin'
      data: {'data': obj}
      method: 'POST'
    .done (response) =>
      alert 'Successfully saved new bot info'
    .fail ->
      alert 'Error uploading json file'

  render: ->
    {div, h2, input} = React.DOM
    div {},
      h2 {}, 'Bot JSON'
      input
        className: 'chat-btn'
        type: 'file'
        name: 'botjson'
        id: 'bot-json-file'
        onChange: @handleChange

module.exports = @NewBot
