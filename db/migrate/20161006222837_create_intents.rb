class CreateIntents < ActiveRecord::Migration
  def change
    create_table :intents do |t|
      t.string :name
      t.text :examples

      t.timestamps null: false
    end
  end
end
