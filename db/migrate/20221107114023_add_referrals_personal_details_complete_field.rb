class AddReferralsPersonalDetailsCompleteField < ActiveRecord::Migration[7.0]
  def change
    add_column :referrals, :personal_details_complete, :boolean
  end
end
