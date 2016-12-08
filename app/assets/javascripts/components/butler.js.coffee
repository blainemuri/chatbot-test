React = require 'react'

@Butler = React.createClass
  componentDidMount: ->
    tl = new TimelineMax()
    tl.add('start')
    tl.to('#eye-1', .2, {height: 0}, 'start')
      .to('#eye-2', .2, {height: 0}, 'start')
      .to('#eye-3', .2, {height: 0}, 'start')
      .to('#eye-4', .2, {height: 0}, 'start')
    tl.timeScale(1)

  render: ->
    {svg, path, circle, g, line} = React.DOM
    svg
      version: '1.1'
      id: 'bot-logo-svg'
      xmlns: 'http://www.w3.org/2000/svg'
      viewBox: '0 0 418 482'
      g
        g
          path
            className: 'bot-st0'
            d: 'M8.6,281.9C8.6,188.3,84.7,103,205.9,103c118.7,0,201.5,74.4,201.5,186.4c0,110.3-85.3,181.4-194.8,181.4
			          C103.1,470.9,8.6,401.5,8.6,281.9z'
        path
          className: 'bot-st1'
          d: "M395.7,287.8c0-94.5-100.3-120.4-182.2-120.4c-102,0-193.1,35.1-193.1,120.4c0,80.3,88.6,118.7,191.4,118.7
		          C302.1,406.5,395.7,375.6,395.7,287.8z"
        circle
          className: 'bot-st2'
          id: 'eye-1'
          cx: '117.3'
          cy: '287'
          r: '57'
        circle
          className: 'bot-st2'
          id: 'eye-2'
          cx: '300.3'
          cy: '287'
          r: '57'
        circle
          className: 'bot-st0'
          id: 'eye-3'
          cx: '300.4'
          cy: '283.4'
          r: '28.8'
        circle
          className: 'bot-st0'
          id: 'eye-4'
          cx: '117.4'
          cy: '283.4'
          r: '28.8'
        line
          className: 'bot-st3'
          x1: '205.9'
          y1: '103.1'
          x2: '205.9'
          y2: '24.2'
        circle
          className: 'bot-st0'
          cx: '205.9'
          cy: '27.8'
          r: '22.7'
        path
          className: 'bot-st0'
          d: 'M242.1,374.3c-20,20-52.3,20-72.3,0'


module.exports = @Butler
