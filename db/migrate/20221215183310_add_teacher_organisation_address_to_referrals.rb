class AddTeacherOrganisationAddressToReferrals < ActiveRecord::Migration[7.0]
  change_table :referrals, bulk: true do |t|
    t.boolean :organisation_address_known
    t.string :organisation_name
    t.string :organisation_address_line_1
    t.string :organisation_address_line_2
    t.string :organisation_town_or_city
    t.string :organisation_postcode, limit: 11
  end
end
