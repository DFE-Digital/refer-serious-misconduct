class RenameTeachingLocationFields < ActiveRecord::Migration[7.0]
  def change
    rename_column :referrals,
                  :teaching_organisation_name,
                  :work_organisation_name
    rename_column :referrals, :teaching_address_line_1, :work_address_line_1
    rename_column :referrals, :teaching_address_line_2, :work_address_line_2
    rename_column :referrals, :teaching_town_or_city, :work_town_or_city
    rename_column :referrals, :teaching_postcode, :work_postcode
  end
end
