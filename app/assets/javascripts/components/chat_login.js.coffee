React = require 'react'
emailPattern = /^([\w.-]+)@([\w.-]+)\.([a-zA-Z.]{2,6})$/i;
passwordPattern = /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z]{8,}$/;
# (/^
# (?=.*\d)                //should contain at least one digit
# (?=.*[a-z])             //should contain at least one lower case
# (?=.*[A-Z])             //should contain at least one upper case
# [a-zA-Z0-9]{8,}         //should contain at least 8 from the mentioned characters
# $/)

@ChatLogin = React.createClass
  getInitialState: ->
    showLogIn: no
    email: ''
    emailClass: ''
    password: ''
    passwordClass: ''
    clicks: 0

  componentDidMount: ->
    TweenLite.fromTo('.credentials', .3,
      {opacity: 0, transform: "rotateY(90deg)"}
      {opacity: 1, transform: "rotateY(0)", delay: .3})

  login: (e) ->
    e.preventDefault()
    login = document.getElementById 'login-timeline'
    outer = document.getElementById 'chat-container'
    tl = new TimelineMax()
    tl.add('start')
    tl.to(login, .3, {left: "-20rem"}, 'start')
      .to(outer, .3, {bottom: "100%", borderRadius: "70%"}, 'start+.1')
    tl.timeScale(1)
    setTimeout ( ->
      window.location.href = '../bot';
    ), 500

  showLogIn: ->
    TweenMax.to(['.chat-logo', '#login-btn'], .3, {opacity: 0})
    setTimeout ( =>
      @setState showLogIn: yes
      setTimeout ( ->
        TweenMax.fromTo('.credentials', .3,
          {opacity: 0, transform: "rotateY(90deg)"}
          {opacity: 1, transform: "rotateY(0)"})
      ), 0
    ), 300

  setEmail: (val) ->
    @setState email: val
    # if val == ''
    #   @setState emailClass: 'gray'
    # else if val.match(emailPattern)
    #   @setState emailClass: 'green'
    # else
    #   @setState emailClass: 'red'

  setPassword: (val) ->
    @setState password: val
    # if val == ''
    #   @setState passwordClass: 'gray'
    # else if val.match(passwordPattern)
    #   @setState passwordClass: 'green'
    # else
    #   @setState passwordClass: 'red'

  dropBowtie: ->
    # @setState clicks: 0
    tl = new TimelineMax()
    tl.add('start')
    tl.to("#bowtie", .4,
      {rotation: -60, ease: Elastic.easeOut,
      delay: .2, transformOrigin: "100% 50%"}, 'start')
      .to('#bowtie', .2,
      {transform: "translate(0px, 100px)", opacity: 0}, 'start+.6')
      .to('#mouth', .5,
      {rotationX: 180, transformOrigin: "25% 25%"}, 'start+.8')
      .to('#robot', .4,
      {rotationX: 20, transformOrigin: "50% 50%"}, 'start+1.3')
      .to('#eyes', .4,
      {transform: "translate(0px, 2px)"}, 'start+1.3')
      .to('#robot', .4,
      {rotationX: 0, transformOrigin: "50% 50%", delay: .5}, 'start+1.7')
      .to('#eyes', .4,
      {transform: "translate(0px, 0px)", delay: .6}, 'start+1.7')
      .to('#mouth', .5,
      {rotationX: 0, transformOrigin: "25% 25%"}, 'start+2.7')
      # .to(['#face', '#antenna', '#eyes'], .5,
      # {transform: "translate(0px, 2px)"}, 'start+1.3')

  clickBowtie: ->
    if @state.clicks == 5
      @dropBowtie()
    else
      @setState clicks: @state.clicks + 1
      tl = new TimelineMax()
      tl.add('start')
      tl.to('#bowtie', .05,
        {rotation: -20, transformOrigin: "50% 50%"}, 'start')
        .to('#bowtie', .1,
        {rotation: 20, transformOrigin: "50% 50%"}, 'start+.05')
        .to('#bowtie', .05,
        {rotation: 0, transformOrigin: "50% 50%"}, 'start+.15')

  animateSelect: (e, num) ->
    text = document.getElementById "placeholder-#{num}"
    bg = document.getElementById "bg-#{num}"
    input = document.getElementById "input-#{num}"
    tl = new TimelineMax()
    tl.add('start')
    tl.to(text, .2, {top: "-13px", transform: "translate(0px, 0px)", color: "black"}, 'start')
      .to(bg, .2, {opacity: 1}, 'start')
      .to(input, .2, {backgroundColor: 'white', borderBottom: "0px", height: "32px"}, 'start')

  animateDeselect: (e, num) ->
    deselect = true
    if (num == 1 && @state.email != '') || (num == 2 && @state.password != '')
      deselect = false
    if deselect
      text = document.getElementById "placeholder-#{num}"
      bg = document.getElementById "bg-#{num}"
      input = document.getElementById "input-#{num}"
      tl = new TimelineMax()
      tl.add('start')
      tl.to(text, .2, {top: "40%", color: "#999999"}, 'start')
        .to(bg, .2, {opacity: 0}, 'start')
        .to(input, .2, {background: "transparent", borderBottom: "1px solid #999999", bottom: "0", height: "100%"}, 'start')


  render: ->
    {div, img, a, input, form, span, svg, path, ellipse, line, g} = React.DOM
    div
      className: 'chat-login'
      id: 'chat-container'
      div
        className: 'vertical-center'
        id: 'login-timeline'
        div className: 'inner-login',
          # img
          #   className: 'chat-logo'
          #   src: @props.chatbot
          # a
          #   className: 'chat-login'
          #   id: 'login-btn'
          #   onClick: @showLogIn
          #   'Login'
          # if @state.showLogIn
          div className: 'credentials',
            div className: 'inner-credentials',
              svg
                id: "chat-bot"
                xmlns: "http://www.w3.org/2000/svg"
                viewBox: "0 0 40 55"
                className: 'profile'
                g
                  id: 'robot'
                  path
                    id: 'face'
                    className: "cls-1"
                    d: "M20.55,40c-10.31,0-19.2-3.83-19.2-11.83,0-8.5,9.14-12,19.37-12,8.22,0,18.28,2.58,18.28,12C39,36.92,29.61,40,20.55,40Z"
                  path
                    d: "M19.79,9.76C7.63,9.76,0,18.26,0,27.59,0,39.51,9.48,46.42,20.46,46.42S40,39.34,40,28.34C40,17.18,31.7,9.76,19.79,9.76ZM20.38,40c-10.31,0-19.2-3.83-19.2-11.83,0-8.5,9.14-12,19.37-12,8.22,0,18.28,2.58,18.28,12C38.83,36.92,29.43,40,20.38,40Z"
                  g
                    id: 'eyes'
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
                    id: 'antenna'
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
                    id: 'mouth'
                    d: "M23.42,34.82a5.15,5.15,0,0,1-7.25,0"
                  path
                    id: 'bowtie'
                    onClick: @clickBowtie
                    d: "M26.79,49.14a1.29,1.29,0,0,0-1.38-.91A9.13,9.13,0,0,0,20,50.8a9.14,9.14,0,0,0-5.41-2.58,1.28,1.28,0,0,0-1.37.9,8.83,8.83,0,0,0,0,4.95,1.29,1.29,0,0,0,1.38.91A9.13,9.13,0,0,0,20,52.42h0A9.14,9.14,0,0,0,25.41,55a1.28,1.28,0,0,0,1.37-.9A8.83,8.83,0,0,0,26.79,49.14Z"
              div className: 'headline', 'Sign in to view log and statistics'
              form
                id: 'login'
                onSubmit: @login
                div className: 'fancy-input',
                  div
                    className: 'placeholder'
                    id: 'placeholder-1'
                    'email'
                  div
                    className: 'background'
                    id: 'bg-1'
                  input
                    className: @state.emailClass
                    id: 'input-1'
                    name: 'email'
                    type: 'text'
                    value: @state.email
                    onChange: (e) => @setEmail e.target.value
                    onFocus: (e) => @animateSelect e, 1
                    onBlur: (e) => @animateDeselect e, 1
                div className: 'fancy-input',
                  div
                    className: 'placeholder'
                    id: 'placeholder-2'
                    'password'
                  div
                    className: 'background'
                    id: 'bg-2'
                  input
                    className: @state.passwordClass
                    id: 'input-2'
                    name: 'password'
                    type: 'password'
                    value: @state.password
                    onChange: (e) => @setPassword e.target.value
                    onFocus: (e) => @animateSelect e, 2
                    onBlur: (e) => @animateDeselect e, 2
                input
                  className: 'input-btn'
                  type: 'submit'
                  value: 'SIGN IN'
              span {}, 'Forget password?'

module.exports = @ChatLogin
