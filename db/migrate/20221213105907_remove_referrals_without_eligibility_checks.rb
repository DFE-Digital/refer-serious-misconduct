class RemoveReferralsWithoutEligibilityChecks < ActiveRecord::Migration[7.0]
  def change
    Referral.where(eligibility_check_id: nil).destroy_all
  end
end
