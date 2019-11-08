class CreatePhotos < ActiveRecord::Migration[5.0]
  def change
    create_table :photos do |table|
      table.integer :user_id
      table.integer :gallery_id

      table.string :file_url
      table.text :description

      table.timestamps null: false
    end
    add_foreign_key :photos, :users
    add_foreign_key :photos, :galleries
  end
end
