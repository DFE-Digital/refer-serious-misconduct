class DeleteReferralEvidences < ActiveRecord::Migration[7.0]
  def change
    drop_table :referral_evidences, if_exists: true do |t|
      t.references :referral, index: true, foreign_key: true
      t.string :filename
      t.timestamps
    end
  end
end
