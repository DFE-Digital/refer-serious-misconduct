class AddAllegationDetailsToReferrals < ActiveRecord::Migration[7.0]
  def change
    change_table :referrals, bulk: true do |t|
      t.string :allegation_format
      t.string :allegation_details
      t.boolean :dbs_notified
      t.boolean :allegation_details_complete
    end
  end
end
