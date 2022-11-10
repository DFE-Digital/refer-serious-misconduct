class AddNameToOrganisation < ActiveRecord::Migration[7.0]
  def change
    add_column :organisations, :name, :string
  end
end
