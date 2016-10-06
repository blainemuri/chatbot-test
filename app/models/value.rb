# == Schema Information
#
# Table name: values
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Value < ActiveRecord::Base
  has_many :entity_values
  has_many :value_synonyms
  has_many :entities, through: :entity_values
  has_many :synonyms, through: :value_synonyms
end
