React = require 'react'

@BotLogo = React.createClass
  render: ->
    {div, svg, g, path, circle, line} = React.DOM
    div {}, 'hello'
    # svg
    #   version: "1.1"
    #   id: "Bot-Logo"
    #   xmlns: "http://www.w3.org/2000/svg"
    #   xmlns:xlink: "http://www.w3.org/1999/xlink"
    #   x: "0px"
    #   y: "0px"
    # 	viewBox: "0 0 1920 1080"
    #   g
    #     g
    #   		path
    #         className: "bot-st0"
    #         d: "M760.6,574.9c0-93.6,76.1-178.9,197.3-178.9c118.7,0,201.5,74.4,201.5,186.4c0,110.3-85.3,181.4-194.8,181.4
    #             C855.1,763.9,760.6,694.5,760.6,574.9z"
    #   	path
    #       className: "bot-st1"
    #       d: "M1147.7,580.8c0-94.5-100.3-120.4-182.2-120.4c-102,0-193.1,35.1-193.1,120.4c0,80.3,88.6,118.7,191.4,118.7
    #           C1054.1,699.5,1147.7,668.6,1147.7,580.8z"
    #   	circle
    #       className: "bot-st2"
    #       cx: "869.3"
    #       cy: "580"
    #       r: "57"
    #   	circle
    #       className: "bot-st2"
    #       cx: "1052.3"
    #       cy: "580"
    #       r: "57"
    #   	circle
    #       className: "bot-st0"
    #       cx: "1052.4"
    #       cy: "576.4"
    #       r: "28.8"
    #   	circle
    #       className: "bot-st0"
    #       cx: "869.4"
    #       cy: "576.4"
    #       r: "28.8"
    #   	line
    #       className: "bot-st3"
    #       x1: "957.9"
    #       y1: "396.1"
    #       x2: "957.9"
    #       y2: "317.2"
    #   	circle
    #       className: "bot-st0"
    #       cx: "957.9"
    #       cy: "320.8"
    #       r: "22.7"
    #   	path
    #       className: "bot-st0"
    #       d: "M994.1,667.3c-20,20-52.3,20-72.3,0"

module.exports = @BotLogo
