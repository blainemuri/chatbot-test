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
  has_many :entity_values
  has_many :values, through: :entity_values
  has_many :bot_entities
  has_many :bots, through: :bot_entities
end
