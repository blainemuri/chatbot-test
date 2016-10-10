class CreateEntityValues < ActiveRecord::Migration
  def change
    create_table :entity_values do |t|

      t.timestamps null: false

      t.belongs_to :entity
      t.belongs_to :value
    end
  end
end
