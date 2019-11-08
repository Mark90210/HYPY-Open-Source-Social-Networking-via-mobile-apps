class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |table|
      table.integer :user_id
      table.integer :photo_id
      table.text :text

      table.timestamps null: false
    end
    add_foreign_key :comments, :users
    add_foreign_key :comments, :photos
  end
end
