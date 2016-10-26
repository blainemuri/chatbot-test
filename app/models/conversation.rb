# == Schema Information
#
# Table name: conversations
#
#  id         :integer          not null, primary key
#  start      :time
#  end        :time
#  entity     :string
#  correct    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Conversation < ActiveRecord::Base
  has_many :comments, -> {order('id ASC')}
end
