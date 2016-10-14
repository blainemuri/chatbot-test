# == Schema Information
#
# Table name: entities
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Entity < ActiveRecord::Base
  has_many :values
  belongs_to :bot
end
