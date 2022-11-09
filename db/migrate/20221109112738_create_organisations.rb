class CreateOrganisations < ActiveRecord::Migration[7.0]
  def change
    create_table :organisations do |t|
      t.belongs_to :referral, null: false, foreign_key: true

      t.timestamps
    end
  end
end
