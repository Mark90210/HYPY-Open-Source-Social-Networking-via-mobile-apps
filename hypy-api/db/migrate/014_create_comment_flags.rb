class CreateCommentFlags < ActiveRecord::Migration[5.0]
  def change
    create_table :comment_flags do |table|
      table.integer :user_id
      table.integer :comment_id

      table.timestamps null: false
    end
    add_foreign_key :comment_flags, :users
    add_foreign_key :comment_flags, :comments
  end
end
