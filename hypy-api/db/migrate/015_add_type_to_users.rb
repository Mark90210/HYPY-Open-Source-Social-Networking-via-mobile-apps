class AddTypeToUsers < ActiveRecord::Migration[5.0]
  def change
    change_table :users do |table|
      table.string :type
    end
  end
end
