class AddTeachingLocationToReferrals < ActiveRecord::Migration[7.0]
  change_table :referrals, bulk: true do |t|
    t.boolean :teaching_location_known
    t.string :teaching_organisation_name
    t.string :teaching_address_line_1
    t.string :teaching_address_line_2
    t.string :teaching_town_or_city
    t.string :teaching_postcode
  end
end
