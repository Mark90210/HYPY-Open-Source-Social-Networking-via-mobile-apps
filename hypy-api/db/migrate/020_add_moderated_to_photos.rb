class AddModeratedToPhotos < ActiveRecord::Migration[5.0]
  def change
    change_table :photos do |table|
		table.boolean :moderated, default: false
    end
  end
end
