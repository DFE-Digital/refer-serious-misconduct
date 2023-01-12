class AddRefferalsAllegationConsiderationDetails < ActiveRecord::Migration[7.0]
  def change
    add_column :referrals, :allegation_consideration_details, :text
  end
end
