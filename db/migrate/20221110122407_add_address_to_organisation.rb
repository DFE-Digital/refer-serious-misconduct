class AddAddressToOrganisation < ActiveRecord::Migration[7.0]
  def change
    change_table :organisations, bulk: true do |t|
      t.string :street_1
      t.string :street_2
      t.string :city
      t.string :postcode
    end
  end
end
