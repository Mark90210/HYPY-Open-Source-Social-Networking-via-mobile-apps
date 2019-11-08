class AddFwUserIdToGalleries < ActiveRecord::Migration[5.0]
  def change
    change_table :galleries do |table|
      table.text :fb_user_id
      table.text :fb_password
      table.text :tw_user_id
      table.text :tw_password
      table.text :ig_user_id
      table.text :ig_password
      table.text :yt_user_id
      table.text :yt_password
    end
  end
end
