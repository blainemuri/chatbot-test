class CreateBots < ActiveRecord::Migration
  def change
    create_table :bots do |t|
      t.text :trainingData
      t.string :name

      t.timestamps null: false
    end
  end
end
