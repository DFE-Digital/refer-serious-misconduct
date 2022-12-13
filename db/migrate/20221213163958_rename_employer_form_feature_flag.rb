class RenameEmployerFormFeatureFlag < ActiveRecord::Migration[7.0]
  def change
    flag = FeatureFlags::Feature.find_by(name: "employer_form")
    flag.update!(name: "referral_form") if flag
  end
end
