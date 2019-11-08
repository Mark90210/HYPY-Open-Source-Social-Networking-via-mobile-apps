class CreateGalleries < ActiveRecord::Migration[5.0]
  def change
    create_table :galleries do |table|
      table.integer :user_id, null: true

      table.string :owner_type
      table.text :description
      table.string :name

      table.timestamps null: false
    end
    add_foreign_key :galleries, :users
  end
end
