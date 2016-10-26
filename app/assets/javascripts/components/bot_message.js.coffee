React = require 'react'

@BotMessage = React.createClass
  getInitialState: ->
    bot: 'neutral'

  componentDidMount: ->
    console.log @props.correct
    if @props.correct == 0
      @setState bot: 'incorrect'
      @animateUnhappy()
    else if @props.correct == 2
      @setState bot: 'correct'
      @animateNeutral()

  setDown: ->
    if !@props.admin
      if @state.bot == 'incorrect'
        @setState bot: 'neutral'
        @animateNeutral()
        @rateComment 1
      else
        @setState bot: 'incorrect'
        @animateUnhappy()
        @rateComment 0

  setUp: ->
    if !@props.admin
      if @state.bot == 'correct'
        @setState bot: 'neutral'
        @animateNeutral()
        @rateComment 1
      else
        @setState bot: 'correct'
        @animateNeutral()
        @rateComment 2

  rateComment: (rating) ->

    $.ajax
      url: '/rateComment'
      data: {'correct': rating, 'id': @props.id, 'conversation': @props.conversationId}
      method: 'POST'

  animateUnhappy: ->
    TweenLite.to("#antenna-#{@props.id}", .3, {rotation: -60, transformOrigin: "50% 100%"})
    TweenLite.to("#mouth-#{@props.id}", .3, {rotationX: 180, transformOrigin: "25% 25%"})
    TweenLite.to("#bowtie-#{@props.id}", .8, {delay: .3, ease: Elastic.easeOut, rotation: -40, transformOrigin: "100% 50%"})

  animateNeutral: ->
    TweenLite.to("#antenna-#{@props.id}", .3, {rotation: 0, transformOrigin: "50% 100%"})
    TweenLite.to("#mouth-#{@props.id}", .3, {rotationX: 0, transformOrigin: "25% 25%"})
    TweenLite.to("#bowtie-#{@props.id}", .3, {rotation: 0, transformOrigin: "100% 50%"})

  render: ->
    {div, img, p, h3, span, svg, path, ellipse, line, g} = React.DOM
    div className: 'bot-message',
      svg
        id: "chat-bot"
        xmlns: "http://www.w3.org/2000/svg"
        viewBox: "0 0 40 55"
        className: 'profile'
        path
          className: "cls-1"
          d: "M20.55,40c-10.31,0-19.2-3.83-19.2-11.83,0-8.5,9.14-12,19.37-12,8.22,0,18.28,2.58,18.28,12C39,36.92,29.61,40,20.55,40Z"
        path
          d: "M19.79,9.76C7.63,9.76,0,18.26,0,27.59,0,39.51,9.48,46.42,20.46,46.42S40,39.34,40,28.34C40,17.18,31.7,9.76,19.79,9.76ZM20.38,40c-10.31,0-19.2-3.83-19.2-11.83,0-8.5,9.14-12,19.37-12,8.22,0,18.28,2.58,18.28,12C38.83,36.92,29.43,40,20.38,40Z"
        ellipse
          cx: "29.27"
          cy: "26.55"
          rx: "2.89"
          ry: "2.87"
        ellipse
          cx: "10.91"
          cy: "26.55"
          rx: "2.89"
          ry: "2.87"
        g
          id: "antenna-#{@props.id}"
          line
            className: "cls-2"
            x1: "19.79"
            y1: "9.76"
            x2: "19.79"
            y2: "1.91"
          ellipse
            cx: "19.79"
            cy: "2.26"
            rx: "2.28"
            ry: "2.26"
        path
          id: "mouth-#{@props.id}"
          d: "M23.42,34.82a5.15,5.15,0,0,1-7.25,0"
        path
          id: "bowtie-#{@props.id}"
          d: "M26.79,49.14a1.29,1.29,0,0,0-1.38-.91A9.13,9.13,0,0,0,20,50.8a9.14,9.14,0,0,0-5.41-2.58,1.28,1.28,0,0,0-1.37.9,8.83,8.83,0,0,0,0,4.95,1.29,1.29,0,0,0,1.38.91A9.13,9.13,0,0,0,20,52.42h0A9.14,9.14,0,0,0,25.41,55a1.28,1.28,0,0,0,1.37-.9A8.83,8.83,0,0,0,26.79,49.14Z"
      div
        className: 'message'
        id: 'message'
        div className: 'heading',
          h3 {}, 'Botler'
          span {}, '10:33pm'
          div className: 'options',
            div
              className: "down #{'selected' if @state.bot == 'incorrect'}"
              onClick: @setDown
            div
              className: "up #{'selected' if @state.bot == 'correct'}"
              onClick: @setUp
        p {}, @props.text
        if @props.intent
          span {}, @props.intent

module.exports = @BotMessage
