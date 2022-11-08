class RemoveReferralsApproximateAgeField < ActiveRecord::Migration[7.0]
  def up
    change_table :referrals, bulk: true do |t|
      t.remove :age_known, if_exists: true
      t.remove :approximate_age, if_exists: true
    end
  end

  def down
    change_table :referrals, bulk: true do |t|
      t.string :age_known, if_not_exists: true
      t.string :approximate_age, if_not_exists: true
    end
  end
end
