class CreateBotNames < ActiveRecord::Migration[5.0]
  def change
    create_table :bot_names do |t|
      t.string :name
      t.integer :count

      t.timestamps
    end
  end
end
