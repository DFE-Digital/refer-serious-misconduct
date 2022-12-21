class RemoveEvidenceReferralsCategoriesField < ActiveRecord::Migration[7.0]
  def change
    remove_column :referral_evidences, :categories, type: :jsonb
  end
end
