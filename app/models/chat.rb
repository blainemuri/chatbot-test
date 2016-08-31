class Chat < ActiveRecord::Base
  has_many :comments
end
