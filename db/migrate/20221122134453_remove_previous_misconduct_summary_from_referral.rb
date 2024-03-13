class RemovePreviousMisconductSummaryFromReferral < ActiveRecord::Migration[7.0]
  def change
    if column_exists?(:referrals, :previous_misconduct_summary)
      remove_column :referrals, :previous_misconduct_summary, :text
    end
  end
end
