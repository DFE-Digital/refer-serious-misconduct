class AddPhoneToReferrer < ActiveRecord::Migration[7.0]
  def change
    add_column :referrers, :phone, :string
  end
end
