class AddLocationToGalleries < ActiveRecord::Migration[5.0]
  def change
    change_table :galleries do |table|
      table.point :location
    end
  end
end
