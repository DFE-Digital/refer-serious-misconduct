class SplitReferrerName < ActiveRecord::Migration[7.0]
  def change
    rename_column :referrers, :name, :first_name
    add_column :referrers, :last_name, :string
  end
end
