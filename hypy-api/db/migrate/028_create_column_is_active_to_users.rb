class CreateColumnIsActiveToUsers < ActiveRecord::Migration[5.1]
  def change
    change_table :users do |table|
      table.boolean :is_active, default: true
    end
  end
end
