class RemoveUserAuthRelatedFeatureFlags < ActiveRecord::Migration[7.0]
  def change
    %i[otp_emails user_accounts].each do |flag|
      record = FeatureFlags::Feature.find_by(name: flag)
      record.destroy if record
    end
  end
end
