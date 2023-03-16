class AddViewSupportAndManageReferralsFieldsToStaffUser < ActiveRecord::Migration[7.0]
  def change
    change_table :staff, bulk: true do |t|
      t.boolean :view_support, default: false
      t.boolean :manage_referrals, default: false
    end
  end
end
