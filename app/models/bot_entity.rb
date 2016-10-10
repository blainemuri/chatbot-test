# == Schema Information
#
# Table name: bot_entities
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  bot_id     :integer
#  entity_id  :integer
#

class BotEntity < ActiveRecord::Base
  belongs_to :bot
  belongs_to :entity
end
