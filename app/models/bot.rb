# == Schema Information
#
# Table name: bots
#
#  id           :integer          not null, primary key
#  trainingData :text
#  name         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Bot < ActiveRecord::Base
  has_many :comments, as: :commentable

  has_many :entities
  has_many :intents
end
