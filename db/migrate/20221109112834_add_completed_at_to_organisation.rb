class AddCompletedAtToOrganisation < ActiveRecord::Migration[7.0]
  def change
    add_column :organisations, :completed_at, :timestamp
  end
end
