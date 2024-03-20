class RemoveReferralsApproximateAgeField < ActiveRecord::Migration[7.0]
  def change
    change_table :referrals, bulk: true do |t|
      reversible do |dir|
        dir.up do
          t.remove :approximate_age if t.column_exists?(:approximate_age)
          t.remove :age_known
          t.boolean :age_known
        end

        dir.down do
          t.string :approximate_age unless t.column_exists?(:approximate_age)
          t.remove :age_known
          t.string :age_known
        end
      end
    end
  end
end
