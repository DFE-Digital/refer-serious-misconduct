class AddTeacherContactDetailsEmailToReferrals < ActiveRecord::Migration[7.0]
  def change
    change_table :referrals, bulk: true do |t|
      t.string :email_known, :boolean
      t.string :email_address, :string, limit: 256
    end
  end
end
