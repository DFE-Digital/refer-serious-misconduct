class FillBlankUserIdsOnReferrals < ActiveRecord::Migration[7.0]
  def change
    # Fill in null user_ids
    # This will be followed by a migration setting this column to not null.
    if Referral.exists?
      Referral.update_all(user_id: 1)
    end
  end
end
