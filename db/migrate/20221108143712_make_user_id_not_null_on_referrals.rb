class MakeUserIdNotNullOnReferrals < ActiveRecord::Migration[7.0]
  def change
    change_column_null :referrals, :user_id, false
  end
end
