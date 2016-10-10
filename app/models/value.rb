# == Schema Information
#
# Table name: values
#
#  id         :integer          not null, primary key
#  name       :string
#  synonyms   :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Value < ActiveRecord::Base
  has_many :entity_values
  has_many :entities, through: :entity_values
  serialize :synonyms, Array
end
