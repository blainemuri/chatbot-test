class CreateValueSynonyms < ActiveRecord::Migration
  def change
    create_table :value_synonyms do |t|

      t.timestamps null: false
    end
  end
end
