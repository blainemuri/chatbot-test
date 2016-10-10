class CreateBotEntities < ActiveRecord::Migration
  def change
    create_table :bot_entities do |t|

      t.timestamps null: false

      t.integer :bot_id
      t.integer :entity_id
    end
  end
end
