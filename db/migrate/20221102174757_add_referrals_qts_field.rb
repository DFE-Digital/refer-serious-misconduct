class AddReferralsQtsField < ActiveRecord::Migration[7.0]
  def change
    add_column :referrals, :has_qts, :string
  end
end
