class AddParentIdToUsers < ActiveRecord::Migration[5.0]
  def change
    change_table :users do |table|
      table.integer :parent_id
    end
    add_foreign_key :users, :users, column: :parent_id 
  end
end
