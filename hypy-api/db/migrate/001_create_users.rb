class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |table|
      table.string :first_name
      table.string :last_name
      table.text :bio
      table.string :email
      table.string :phone
      table.string :password_hash
      table.string :salt
      table.string :device_identifier
      table.string :token
      table.boolean :is_admin

      table.timestamps null: false
    end
  end
end
