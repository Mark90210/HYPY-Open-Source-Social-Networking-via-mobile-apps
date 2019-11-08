class CreateSponsorUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :sponsor_users do |table|
      table.integer :sponsor_id
      table.integer :user_id

      table.integer :access_level

      table.timestamps null: false
    end
    add_foreign_key :sponsor_users, :sponsors
    add_foreign_key :sponsor_users, :users
  end
end
