class AddJobTitleToReferral < ActiveRecord::Migration[7.0]
  def change
    add_column :referrals, :job_title, :string
  end
end
