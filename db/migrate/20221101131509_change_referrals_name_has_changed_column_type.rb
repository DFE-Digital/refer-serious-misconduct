class ChangeReferralsNameHasChangedColumnType < ActiveRecord::Migration[7.0]
  def up
    change_column :referrals, :name_has_changed, :string
  end
end
