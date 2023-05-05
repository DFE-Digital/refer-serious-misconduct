class AddRecentlyComplainedToEligibilityCheck < ActiveRecord::Migration[7.0]
  def change
    add_column :eligibility_checks, :recently_complained, :boolean
  end
end
