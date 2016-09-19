class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :body
      t.text :context
      t.integer :correct
      t.references :commentable, polymorphic: true, index: true
      t.references :conversation, index: true

      t.timestamps null: false
    end
  end
end
