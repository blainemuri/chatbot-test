React = require 'react'

@Shadow = React.createClass
  render: ->
    {svg, g, path} = React.DOM
    svg
      width: "78px"
      height: "7px"
      viewBox: "0 0 78 7"
      version: "1.1"
      xmlns: "http://www.w3.org/2000/svg"
      className: 'bot-shadow'
      g
        id: "Page-1"
        stroke: "none"
        strokeWidth: "1"
        fill: "none"
        fillRule: "evenodd"
        fillOpacity: "0.600000024"
        opacity: "0.900000036"
        g
          id: "Desktop-HD-Copy-36"
          transform: "translate(-149.000000, -127.000000)"
          fill: "#D8D8D8"
          g
            id: "Group-7"
            transform: "translate(-536.000000, 0.000000)"
            path
              d: "M724,133.5 C745.302412,133.5 762.571429,132.156854 762.571429,130.5 C762.571429,128.843146 745.302412,127.5 724,127.5 C702.697588,127.5 685.428571,128.843146 685.428571,130.5 C685.428571,132.156854 702.697588,133.5 724,133.5 Z"
              id: "Oval-3-Copy"

module.exports = @Shadow
