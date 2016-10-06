class CreateEntityValues < ActiveRecord::Migration
  def change
    create_table :entity_values do |t|

      t.timestamps null: false
    end
  end
end
