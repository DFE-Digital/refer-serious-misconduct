class AddTeacherContactDetailsEmailToReferrals < ActiveRecord::Migration[7.0]
  def change
    change_table :referrals, bulk: true do |t|
      t.boolean :email_known
      t.string :email_address, limit: 256
    end
  end
end
