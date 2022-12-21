class AddRoleEndDateKnownToReferral < ActiveRecord::Migration[7.0]
  def change
    add_column :referrals, :role_end_date_known, :boolean
  end
end
