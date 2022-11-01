class AddDateOfBirthToReferrals < ActiveRecord::Migration[7.0]
  def change
    change_table :referrals, bulk: true do |t|
      t.date :date_of_birth
      t.string :age_known
      t.string :approximate_age
    end
  end
end
