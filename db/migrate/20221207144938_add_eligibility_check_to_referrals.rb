class AddEligibilityCheckToReferrals < ActiveRecord::Migration[7.0]
  def change
    add_reference :referrals, :eligibility_check, foreign_key: true
  end
end
