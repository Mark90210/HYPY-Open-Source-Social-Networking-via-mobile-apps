class RemoveSponsors < ActiveRecord::Migration[5.0]
  def change
    drop_table :sponsors
  end
end
