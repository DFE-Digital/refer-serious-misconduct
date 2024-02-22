class AddDeveloperToStaff < ActiveRecord::Migration[7.0]
  def change
    add_column :staff, :developer, :boolean, default: false
  end
end
