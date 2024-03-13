class RemoveReferralEvidencesCategoriesOther < ActiveRecord::Migration[7.0]
  def change
    remove_column :referral_evidences, :categories_other, type: :string if column_exists?(:referral_evidences, :categories_other)
  end
end
