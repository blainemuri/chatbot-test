React = require 'react'
Giphy = require('giphy-api')('dc6zaTOxFJmzC')

@BotMessage = React.createClass
  getInitialState: ->
    bot: 'neutral'
    time: ""
    url: ''

  componentWillMount: ->
    date = new Date(@props.comment.created_at)
    hours = date.getHours()
    minutes = date.getMinutes()
    ampm = if hours >= 12 then 'pm' else 'am'
    hours = hours%12
    hours = if hours == 0 then 12 else hours
    minutes = if minutes < 10 then '0'+minutes else minutes

    dateTime = hours + ':' + minutes + ' ' + ampm
    @setState time: dateTime

    @getGiphyImage()

  componentDidMount: ->
    if @props.comment.correct == 0
      @setState bot: 'incorrect'
      @animateUnhappy()
    else if @props.comment.correct == 2
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
    if !@props.admin
      $.ajax
        url: '/rateComment'
        data: {'correct': rating, 'id': @props.comment.id, 'conversation': @props.comment.conversation_id}
        method: 'POST'

  # animateUnhappy: ->
  #   TweenLite.to("#antenna-#{@props.animate}", .3, {rotation: -60, transformOrigin: "50% 100%"})
  #   TweenLite.to("#mouth-#{@props.animate}", .3, {rotationX: 180, transformOrigin: "25% 25%"})
  #   TweenLite.to("#bowtie-#{@props.animate}", .8, {delay: .3, ease: Elastic.easeOut, rotation: -40, transformOrigin: "100% 50%"})
  #
  # animateNeutral: ->
  #   TweenLite.to("#antenna-#{@props.animate}", .3, {rotation: 0, transformOrigin: "50% 100%"})
  #   TweenLite.to("#mouth-#{@props.animate}", .3, {rotationX: 0, transformOrigin: "25% 25%"})
  #   TweenLite.to("#bowtie-#{@props.animate}", .3, {rotation: 0, transformOrigin: "100% 50%"})

  getGiphyImage: ->
    url = ''
    Giphy.search({
      q: 'funny+cat',
      rating: 'g'
    }, (err, res) =>
       url = res.data[Math.floor(Math.random() * 25)].embed_url.toString() + '?html5=true'
       @setState url: url
    )

  render: ->
    {div, img, p, h3, span, svg, path, ellipse, circle, line, g, iframe} = React.DOM
    div className: 'bot-message',
      div
        className: 'message'
        id: 'message'
        # div className: 'heading',
        #   h3 {}, 'Originate Chatbot'
        #   span {}, @state.time
        p {}, @props.comment.body
        # if @props.intent
        #   span {}, @props.intent
        # if @props.gif
        #   iframe
        #     src: @state.url
        #     height: "200"
        #     frameBorder: "0"
        #     className: "giphy-embed"

module.exports = @BotMessage
