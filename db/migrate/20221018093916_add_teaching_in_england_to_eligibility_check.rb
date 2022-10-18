class AddTeachingInEnglandToEligibilityCheck < ActiveRecord::Migration[7.0]
  def change
    add_column :eligibility_checks, :teaching_in_england, :string
  end
end
