class AddComplaintStatusToEligibilityCheck < ActiveRecord::Migration[7.0]
  def change
    add_column :eligibility_checks, :complaint_status, :string
  end
end
