# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# comment_list = [
#   ['Blaine', "Hey how's it going, Mr. Botler?"],
#   ['Botler', "Well! Always a good day for a bot! What can I help you with?"],
#   ['Blaine', "Book me a room in Marvin for 2pm tomorrow"],
#   ['Botler', "How long would you like to book the room?"],
#   ['Blaine', "1 hour"],
#   ['Botler', "I've booked you Marvin for 1 hour at 2pm tomorrow!"]
# ]
#
# chat = Chat.create(email: 'dummy@test.com')
# comment_list.each do |user, text|
#   Comment.create(user: user, text: text)
# end

# params = { chat: {
#   email: 'dummy@test.com', comments_attributes: [
#     {user: 'User', text: "Hey how's it going, Mr. Botler?"},
#     {user: 'Botler', text: "Well! Always a good day for a bot! What can I help you with?"},
#     {user: 'User', text: "Book me a room in Marvin for 2pm tomorrow"},
#     {user: 'Botler', text: "How long would you like to book the room?"},
#     {user: 'User', text: "1 hour"},
#     {user: 'Botler', text: "I've booked you Marvin for 1 hour at 2pm tomorrow!"}
#   ]
# }}
#
# chat = Chat.create(params[:chat])

User.create(username: 'admin', password: 'password', accessLevel: 1)
Bot.create(name: 'originate')

# TODO: Be sure to seed in the initial json for the bot if it's not present


# class Member < ActiveRecord::Base
#   has_many :posts
#   accepts_nested_attributes_for :posts
# end
#
# params = { member: {
#   name: 'joe', posts_attributes: [
#     { title: 'Kari, the awesome Ruby documentation browser!' },
#     { title: 'The egalitarian assumption of the modern citizen' },
#     { title: '', _destroy: '1' } # this will be ignored
#   ]
# }}
#
# member = Member.create(params[:member])
# member.posts.length # => 2
# member.posts.first.title # => 'Kari, the awesome Ruby documentation browser!'
# member.posts.second.title # => 'The egalitarian assumption of the modern citizen'
