class Chat < ActiveRecord::Base
  has_many :comments
  # validates :email, precence: true, length: { maximum: 50 }
end
