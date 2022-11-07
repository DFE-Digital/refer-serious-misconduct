class AddJobTitleToReferrer < ActiveRecord::Migration[7.0]
  def change
    add_column :referrers, :job_title, :string
  end
end
