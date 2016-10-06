class CreateSynonyms < ActiveRecord::Migration
  def change
    create_table :synonyms do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
