class AddPreviousMisconductSummaryToReferral < ActiveRecord::Migration[7.0]
  def change
    add_column :referrals, :previous_misconduct_summary, :text
  end
end
