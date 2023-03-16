class RemovePreviousMisconductSummaryFromReferral < ActiveRecord::Migration[7.0]
  def change
    remove_column :referrals, :previous_misconduct_summary, :text, if_exists: true
  end
end
