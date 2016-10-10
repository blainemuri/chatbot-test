# == Schema Information
#
# Table name: entity_values
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  entity_id  :integer
#  value_id   :integer
#

class EntityValue < ActiveRecord::Base
  belongs_to :entity
  belongs_to :value
end
