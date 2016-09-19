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
#
# Indexes
#
#  index_comments_on_commentable_type_and_commentable_id  (commentable_type,commentable_id)
#  index_comments_on_conversation_id                      (conversation_id)
#

class Comment < ActiveRecord::Base
  belongs_to :conversation
  belongs_to :commentable, polymorphic: true
end
