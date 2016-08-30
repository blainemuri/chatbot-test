React = require 'react'

@TopNav = React.createClass
  render: ->
    {div, a} = React.DOM
    div className: 'top-nav',
      div className: 'logo-left',
        React.createElement Logo, null
      a
        className: 'right nav-link'
        href: '/solutions'
        'Solutions'
      a
        className: 'right nav-link'
        href: '/technology'
        'Technology'
      a
        className: 'right nav-link'
        href: '/design'
        'Design'
      a
        className: 'right nav-link'
        href: '/people'
        'People'
      a
        className: 'right nav-link'
        href: '/resources'
        'Resources'
      a
        className: 'right nav-link'
        href: '/careers'
        'Careers'

module.exports = @TopNav
