class RemoveReferralsApproximateAgeField < ActiveRecord::Migration[7.0]
  def change
    change_table :referrals, bulk: true do |t|
      reversible do |dir|
        dir.up do
          t.remove :approximate_age, if_exists: true
          t.remove :age_known, if_exists: true
          t.boolean :age_known, if_not_exists: true
        end

        dir.down do
          t.string :approximate_age, if_not_exists: true
          t.remove :age_known, if_exists: true
          t.string :age_known, if_not_exists: true
        end
      end
    end
  end
end
