class CreateReferrers < ActiveRecord::Migration[7.0]
  def change
    create_table :referrers do |t|
      t.references :referral, null: false, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
