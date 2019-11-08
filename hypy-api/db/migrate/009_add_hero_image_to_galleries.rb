class AddHeroImageToGalleries < ActiveRecord::Migration[5.0]
  def change
    change_table :galleries do |table|
      table.string :hero_image
    end
  end
end
