class AddProfileImageToUsers < ActiveRecord::Migration[5.0]
  def change
    change_table :users do |table|
      table.string :profile_image
    end
  end
end
