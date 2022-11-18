class AddEmploymentStatusToReferral < ActiveRecord::Migration[7.0]
  def change
    change_table :referrals, bulk: true do |t|
      t.string :employment_status
      t.date :role_end_date
      t.string :reason_leaving_role
    end
  end
end
