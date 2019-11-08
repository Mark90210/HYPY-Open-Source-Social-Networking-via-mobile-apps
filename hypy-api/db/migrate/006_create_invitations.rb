class CreateInvitations < ActiveRecord::Migration[5.0]
  def change
    create_table :invitations do |table|
      table.integer :inviter_id
      table.integer :invitee_id
      table.integer :gallery_id

      table.string :file_url
      table.text :description

      table.timestamps null: false
    end
    add_foreign_key :invitations, :users, column: :inviter_id
    add_foreign_key :invitations, :users, column: :invitee_id
    add_foreign_key :invitations, :galleries
  end
end
