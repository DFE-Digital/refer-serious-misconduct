class AddEvidenceFieldsToReferrals < ActiveRecord::Migration[7.0]
  def change
    change_table :referrals, bulk: true do |t|
      t.boolean :has_evidence
      t.boolean :evidence_details_complete
    end
  end
end
