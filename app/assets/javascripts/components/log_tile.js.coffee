React = require 'react'

@LogTile = React.createClass
  getInitialState: ->
    botName: ""
    date: ""

  getMonth: (num) ->
    switch num
      when 0 then 'January'
      when 1 then 'February'
      when 2 then 'March'
      when 3 then 'April'
      when 4 then 'May'
      when 5 then 'June'
      when 6 then 'July'
      when 7 then 'August'
      when 8 then 'September'
      when 9 then 'October'
      when 10 then 'November'
      when 11 then 'December'

  componentWillMount: ->
    conv = @props.conversation

    date = new Date(conv[0].created_at)
    day = date.getUTCDate()
    month = @getMonth(date.getUTCMonth())
    year = date.getUTCFullYear()
    dateTime = month + " " + day + ", " + year
    @setState date: dateTime

    @props.bots.map (bot) =>
      if bot.id == @props.botId
        @setState botName: bot.name

  handleClick: (e) ->
    e.stopPropagation()
    e.preventDefault()
    @props.open @props.conversation, @state.date

  render: ->
    {a, div, h5, h6, img, p, span} = React.DOM
    div
      className: 'log-tile'
      onClick: @handleClick
      div className: 'header-left',
        div className: 'username', "User: #{@props.conversation[0].user}"
        span {}, @state.date
      div className: 'header-right',
        img
          src: @props.profile
          alt: 'User'
      p {}, "Conversation with bot: #{@state.botName}"

module.exports = @LogTile
