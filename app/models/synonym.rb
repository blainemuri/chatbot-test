# == Schema Information
#
# Table name: synonyms
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Synonym < ActiveRecord::Base
  has_many :value_synonyms
  has_many :synonyms, through: :value_synonyms
end
