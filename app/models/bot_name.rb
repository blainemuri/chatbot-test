# == Schema Information
#
# Table name: bot_names
#
#  id         :integer          not null, primary key
#  name       :string
#  count      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class BotName < ApplicationRecord
end
