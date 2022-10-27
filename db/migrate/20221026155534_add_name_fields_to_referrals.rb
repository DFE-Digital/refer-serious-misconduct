class AddNameFieldsToReferrals < ActiveRecord::Migration[7.0]
  def change
    change_table :referrals, bulk: true do |t|
      t.string :first_name
      t.string :last_name
      t.string :previous_name
      t.integer :name_has_changed
    end
  end
end
