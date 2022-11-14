class AddPreviousMisconductToReferral < ActiveRecord::Migration[7.0]
  def change
    change_table :referrals, bulk: true do |t|
      t.timestamp :previous_misconduct_completed_at
      t.timestamp :previous_misconduct_deferred_at
    end
  end
end
