class CreateEligibilityChecks < ActiveRecord::Migration[7.0]
  def change
    create_table :eligibility_checks do |t|
      t.string :reporting_as, null: false
      t.timestamps
    end
  end
end
