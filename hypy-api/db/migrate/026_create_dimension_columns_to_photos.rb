class CreateDimensionColumnsToPhotos < ActiveRecord::Migration[5.1]
  def change
    change_table :photos do |table|
      table.string :dimension
    end
  end
end
