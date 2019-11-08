class CreateColumnThumbPhotoToPhotos < ActiveRecord::Migration[5.1]
  def change
    change_table :photos do |table|
      table.string :thumb_photo
    end
  end
end
