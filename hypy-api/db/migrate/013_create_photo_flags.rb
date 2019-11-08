class CreatePhotoFlags < ActiveRecord::Migration[5.0]
  def change
    create_table :photo_flags do |table|
      table.integer :user_id
      table.integer :photo_id

      table.timestamps null: false
    end
    add_foreign_key :photo_flags, :users
    add_foreign_key :photo_flags, :photos
  end
end
