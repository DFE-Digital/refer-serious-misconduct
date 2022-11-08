class AddContactDetailsCompletedToReferrals < ActiveRecord::Migration[7.0]
  def change
    add_column :referrals, :contact_details_complete, :boolean
  end
end
