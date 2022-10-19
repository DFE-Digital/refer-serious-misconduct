class AddIsTeacherToEligibilityCheck < ActiveRecord::Migration[7.0]
  def change
    add_column :eligibility_checks, :is_teacher, :string
  end
end
