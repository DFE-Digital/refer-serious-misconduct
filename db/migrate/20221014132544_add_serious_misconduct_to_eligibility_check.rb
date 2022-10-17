class AddSeriousMisconductToEligibilityCheck < ActiveRecord::Migration[7.0]
  def change
    add_column :eligibility_checks, :serious_misconduct, :string
  end
end
