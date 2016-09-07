class Comment < ActiveRecord::Base
  belongs_to :chat
  # validates :user, presence: true
  # validates :text, presence: true
end
