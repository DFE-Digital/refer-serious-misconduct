class AddContinueWithToEligibilityChecks < ActiveRecord::Migration[7.0]
  def change
    add_column :eligibility_checks, :continue_with, :string
  end
end
