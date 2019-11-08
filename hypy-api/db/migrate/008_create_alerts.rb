class CreateAlerts < ActiveRecord::Migration[5.0]
  def change
    create_table :alerts do |table|
      table.integer :user_id

      table.string :type
      table.string :title
      table.text :messge

      table.json :data

      table.timestamps null: false
      table.datetime :expires_at
      table.datetime :sent_at
      table.datetime :delivered_at
    end
    add_foreign_key :alerts, :users
  end
end
