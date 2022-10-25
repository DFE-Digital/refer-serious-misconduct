class AddHaveComplainedToEligibilityCheck < ActiveRecord::Migration[7.0]
  def change
    add_column :eligibility_checks, :complained, :boolean
  end
end
