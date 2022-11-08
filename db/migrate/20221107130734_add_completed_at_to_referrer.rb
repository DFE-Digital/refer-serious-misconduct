class AddCompletedAtToReferrer < ActiveRecord::Migration[7.0]
  def change
    add_column :referrers, :completed_at, :timestamp
  end
end
