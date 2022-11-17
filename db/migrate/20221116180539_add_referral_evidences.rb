class AddReferralEvidences < ActiveRecord::Migration[7.0]
  def change
    create_table :referral_evidences do |t|
      t.string :filename
      t.jsonb :categories
      t.string :categories_other
      t.references :referral, index: true, foreign_key: true
      t.timestamps
    end
  end
end
