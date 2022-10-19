class AddUnsupervisedTeachingToEligibilityCheck < ActiveRecord::Migration[7.0]
  def change
    add_column :eligibility_checks, :unsupervised_teaching, :string
  end
end
