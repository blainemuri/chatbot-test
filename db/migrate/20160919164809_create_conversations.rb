class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.time :start
      t.time :end
      t.string :entity
      t.integer :correct

      t.timestamps null: false
    end
  end
end
