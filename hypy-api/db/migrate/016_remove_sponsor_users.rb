class RemoveSponsorUsers < ActiveRecord::Migration[5.0]
  def change
    drop_table :sponsor_users
  end
end
