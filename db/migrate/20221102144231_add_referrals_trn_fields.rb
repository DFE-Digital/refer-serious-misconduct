class AddReferralsTrnFields < ActiveRecord::Migration[7.0]
  def change
    change_table :referrals, bulk: true do |t|
      t.string :trn
      t.boolean :trn_known
    end
  end
end
