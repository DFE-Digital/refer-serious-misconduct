class AddRoleStartDateToReferrals < ActiveRecord::Migration[7.0]
  def change
    change_table :referrals, bulk: true do |t|
      t.boolean :role_start_date_known
      t.date :role_start_date
    end
  end
end
