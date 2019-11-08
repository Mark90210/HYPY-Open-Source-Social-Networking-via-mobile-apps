class CreateLikes < ActiveRecord::Migration[5.0]
  def change
    create_table :likes do |table|
      table.integer :user_id
      table.integer :photo_id

      table.timestamps null: false
    end
    add_foreign_key :likes, :users
    add_foreign_key :likes, :photos
  end
end
