class AddTeacherDutiesDetailsToReferrals < ActiveRecord::Migration[7.0]
  change_table :referrals, bulk: true do |t|
    t.string :duties_format
    t.string :duties_details
  end
end
