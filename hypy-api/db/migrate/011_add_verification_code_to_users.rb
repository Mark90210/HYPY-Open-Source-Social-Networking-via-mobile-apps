class AddVerificationCodeToUsers < ActiveRecord::Migration[5.0]
  def change
    change_table :users do |table|
      table.string :verification_code
    end
  end
end
