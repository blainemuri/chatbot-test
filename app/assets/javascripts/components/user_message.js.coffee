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

  componentDidMount: ->
    tl = new TimelineMax({repeat:-1, repeatDelay:.2})
    tl.add('start')
    if @props.loading
      tl.to('#circle-1', .3, {transform: "translateY(5px)"}, 'start')
        .to('#circle-2', .3, {transform: "translateY(5px)"}, 'start+=.15')
        .to('#circle-3', .3, {transform: "translateY(5px)"}, 'start+=.3')
        .to('#circle-1', .3, {transform: "translateY(0px)"}, 'start+=.6')
        .to('#circle-2', .3, {transform: "translateY(0px)"}, 'start+=.75')
        .to('#circle-3', .3, {transform: "translateY(0px)"}, 'start+=.9')

  render: ->
    {div, img, p, h3, span, svg, circle} = React.DOM
    div className: 'user-message',
      div className: 'message',
        div className: 'heading',
          h3 {}, 'Originator'
          span {}, @state.time
        p {}, @props.comment.body
      if @props.loading
        svg
          version: "1.1"
          id: "Layer_1"
          xmlns: "http://www.w3.org/2000/svg"
          x: "0px"
          y: "0px"
          viewBox: "0 0 20 12"
          className: 'loading-dots'
          circle
            id: 'circle-1'
            cx: "3"
            cy: "3"
            r: "2"
          circle
            id: 'circle-2'
            cx: "10"
            cy: "3"
            r: "2"
          circle
            id: 'circle-3'
            cx: "17"
            cy: "3"
            r: "2"

module.exports = @UserMessage
