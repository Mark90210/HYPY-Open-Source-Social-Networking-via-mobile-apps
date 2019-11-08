class AddConfirmedToUsers < ActiveRecord::Migration[5.0]
  def change
    change_table :users do |table|
		table.boolean :confirmed, default: false
    end
  end
end
