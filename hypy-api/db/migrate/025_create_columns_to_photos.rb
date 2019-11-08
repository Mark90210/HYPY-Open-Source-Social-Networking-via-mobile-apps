class CreateColumnsToPhotos < ActiveRecord::Migration[5.1]
  def change
    change_table :photos do |table|
      table.string :location
    end
  end
end
