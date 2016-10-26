React = require 'react'

@UserMessage = React.createClass
  getInitialState: ->
    time: ""

  componentWillMount: ->
    date = new Date(@props.comment.created_at)
    hours = date.getHours()
    minutes = date.getMinutes()
    ampm = if hours >= 12 then 'pm' else 'am'
    hours = hours%12
    hours = if hours == 0 then 12 else hours # the hour '0' should be 12
    minutes = if minutes < 10 then '0'+minutes else minutes

    dateTime = hours + ':' + minutes + ' ' + ampm
    @setState time: dateTime

  render: ->
    {div, img, p, h3, span} = React.DOM
    div className: 'user-message',
      img
        src: @props.pic
        alt: 'Botler'
      div className: 'message',
        div className: 'heading',
          h3 {}, 'User'
          span {}, @state.time
        p {}, @props.comment.body

module.exports = @UserMessage
