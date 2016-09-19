# == Schema Information
#
# Table name: users
#
#  id          :integer          not null, primary key
#  username    :string
#  password    :string
#  accessLevel :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class User < ActiveRecord::Base
  has_many :comments, as: :commentable
end
