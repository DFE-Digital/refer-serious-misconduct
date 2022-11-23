class AddDetailedAccountToReferral < ActiveRecord::Migration[7.0]
  def change
    change_table :referrals, bulk: true do |t|
      t.text :previous_misconduct_details
      t.timestamp :previous_misconduct_details_incomplete_at
    end
  end
end
