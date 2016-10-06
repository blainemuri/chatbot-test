# == Schema Information
#
# Table name: intents
#
#  id         :integer          not null, primary key
#  name       :string
#  examples   :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Intent < ActiveRecord::Base
  serialize :examples, Array
end
