# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  body             :text
#  context          :text
#  correct          :integer
#  commentable_id   :integer
#  commentable_type :string
#  conversation_id  :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  bot_id           :integer
#
# Indexes
#
#  index_comments_on_bot_id                               (bot_id)
#  index_comments_on_commentable_type_and_commentable_id  (commentable_type,commentable_id)
#  index_comments_on_conversation_id                      (conversation_id)
#
# Foreign Keys
#
#  fk_rails_e7f962f827  (bot_id => bots.id)
#

class Comment < ActiveRecord::Base
  belongs_to :conversation
  belongs_to :commentable, polymorphic: true
end
