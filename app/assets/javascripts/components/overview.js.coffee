React = require 'react'

@Overview = React.createClass
  render: ->
    {div} = React.DOM
    div id: 'overview',
      div className: 'tile-container',
        div className: 'tile',
          div className: 'title', 'Exosphere'
          div className: 'overview', 'Data'
        div className: 'tile',
          div className: 'title', 'XMS'
          div className: 'overview', 'Data'
        div
          className: 'tile'
          onClick: (e) => @props.setPage 'Botler'
          div className: 'title', 'Botler'
          div className: 'overview', 'Data'

module.exports = @Overview
