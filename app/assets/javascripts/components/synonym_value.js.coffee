React = require 'react'

@SynonymValue = React.createClass
  render: -> 
    {div} = React.DOM
    div className: 'synonym', @props.syn 

module.exports = @SynonymValue
