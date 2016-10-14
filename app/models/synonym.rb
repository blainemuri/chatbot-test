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
  belongs_to :value
end
