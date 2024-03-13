class RemoveReferralEvidencesCategoriesOther < ActiveRecord::Migration[7.0]
  def change
    if column_exists?(:referral_evidences, :categories_other)
      remove_column :referral_evidences, :categories_other, type: :string
    end
  end
end
