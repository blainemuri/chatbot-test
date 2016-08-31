class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :user
      t.string :text

      t.belongs_to :chat
      t.timestamps null: false
    end
  end
end
