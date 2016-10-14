class AddBotIdToConversation < ActiveRecord::Migration
  def change
    add_reference :comments, :bot, index: true, foreign_key: true
  end
end
