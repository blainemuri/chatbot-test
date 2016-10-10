# == Schema Information
#
# Table name: intents
#
#  id         :integer          not null, primary key
#  name       :string
#  examples   :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  bot_id     :integer
#

class Intent < ActiveRecord::Base
  serialize :examples, Array
  belongs_to :bot
end
