class AddReferrals < ActiveRecord::Migration[7.0]
  def change
    create_table :referrals, &:timestamps
  end
end
