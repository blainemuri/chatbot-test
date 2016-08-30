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
    if val == ''
      @setState emailClass: 'gray'
    else if val.match(emailPattern)
      @setState emailClass: 'green'
    else
      @setState emailClass: 'red'

  setPassword: (val) ->
    @setState password: val
    if val == ''
      @setState passwordClass: 'gray'
    else if val.match(passwordPattern)
      @setState passwordClass: 'green'
    else
      @setState passwordClass: 'red'

  render: ->
    {div, img, a, input, form} = React.DOM
    div
      className: 'chat-login'
      id: 'chat-container'
      div
        className: 'vertical-center'
        id: 'login-timeline'
        div className: 'inner-login',
          img
            className: 'chat-logo'
            src: @props.chatbot
          a
            className: 'chat-login'
            id: 'login-btn'
            onClick: @showLogIn
            'Login'
          if @state.showLogIn
            div className: 'credentials',
              div className: 'inner-credentials',
                img
                  className: 'profile'
                  src: @props.chatbot
                div className: 'info', 'Sign in to view log and statistics'
                form
                  id: 'login'
                  onSubmit: @login
                  input
                    placeholder: 'email'
                    className: @state.emailClass
                    name: 'email'
                    type: 'text'
                    value: @state.email
                    onChange: (e) => @setEmail e.target.value
                  input
                    placeholder: 'password'
                    className: @state.passwordClass
                    name: 'password'
                    type: 'password'
                    value: @state.password
                    onChange: (e) => @setPassword e.target.value
                  input
                    className: 'input-btn'
                    type: 'submit'
                    value: 'SIGN IN'



module.exports = @ChatLogin
