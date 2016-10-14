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
  belongs_to :entity
  serialize :synonyms, Array
end
