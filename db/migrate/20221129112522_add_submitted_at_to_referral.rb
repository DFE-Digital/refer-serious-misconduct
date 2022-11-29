class AddSubmittedAtToReferral < ActiveRecord::Migration[7.0]
  def change
    add_column :referrals, :submitted_at, :timestamp
  end
end
