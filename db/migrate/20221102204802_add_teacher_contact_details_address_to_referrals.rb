class AddTeacherContactDetailsAddressToReferrals < ActiveRecord::Migration[7.0]
  def change
    change_table :referrals, bulk: true do |t|
      t.boolean :address_known
      t.string :address_line_1
      t.string :address_line_2
      t.string :town_or_city
      t.string :postcode, limit: 11
      t.string :country
    end
  end
end
