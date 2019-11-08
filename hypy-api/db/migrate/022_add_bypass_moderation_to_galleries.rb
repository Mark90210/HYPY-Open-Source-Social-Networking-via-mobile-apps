class AddBypassModerationToGalleries < ActiveRecord::Migration[5.0]
  def change
    change_table :galleries do |table|
      table.boolean :bypass_moderation, default: false
    end
  end
end
