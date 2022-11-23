class AddSameOrganisationToReferral < ActiveRecord::Migration[7.0]
  def change
    add_column :referrals, :same_organisation, :boolean
  end
end
