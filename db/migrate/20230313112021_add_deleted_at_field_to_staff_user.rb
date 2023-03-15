class AddDeletedAtFieldToStaffUser < ActiveRecord::Migration[7.0]
  def change
    change_table :staff, bulk: true do |t|
      t.timestamp :deleted_at
    end
  end
end
