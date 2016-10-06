# == Schema Information
#
# Table name: value_synonyms
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ValueSynonym < ActiveRecord::Base
  belongs_to :value
  belongs_to :synonym
end
