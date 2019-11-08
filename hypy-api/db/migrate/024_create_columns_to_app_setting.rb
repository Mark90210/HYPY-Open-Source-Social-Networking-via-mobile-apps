class CreateColumnsToAppSetting < ActiveRecord::Migration[5.1]
  def change
    create_table :app_settings do |table|
      table.string :name
      table.string :value

      table.timestamps null: false
    end
  end
end
