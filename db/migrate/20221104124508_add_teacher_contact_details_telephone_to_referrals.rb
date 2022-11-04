class AddTeacherContactDetailsTelephoneToReferrals < ActiveRecord::Migration[7.0]
  def change
    change_table :referrals, bulk: true do |t|
      t.boolean :phone_known
      t.string :phone_number
    end
  end
end
