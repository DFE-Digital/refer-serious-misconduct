class AddTeacherRoleCompleteToReferrals < ActiveRecord::Migration[7.0]
  def change
    add_column :referrals, :teacher_role_complete, :boolean
  end
end
