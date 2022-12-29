class RenameTeachingLocationKnown < ActiveRecord::Migration[7.0]
  def change
    rename_column :referrals, :teaching_location_known, :working_location_known
  end
end
