class AddNiNumberToReferral < ActiveRecord::Migration[7.0]
  def change
    change_table :referrals, bulk: true do |t|
      t.string :ni_number
      t.boolean :ni_number_known
    end
  end
end
