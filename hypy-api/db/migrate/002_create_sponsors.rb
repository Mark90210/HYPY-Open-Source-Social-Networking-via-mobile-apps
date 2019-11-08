class CreateSponsors < ActiveRecord::Migration[5.0]
  def change
    create_table :sponsors do |table|
      table.string :name
      table.text :bio

      table.timestamps null: false
    end
  end
end
