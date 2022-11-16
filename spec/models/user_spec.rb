require "rails_helper"

RSpec.describe User, type: :model do
  describe "#latest_referral" do
    it "returns the most recently created referral" do
      user = create(:user)
      expected_referral =
        create(:referral, user:, created_at: Time.zone.now + 1.hour)
      create(:referral, user:, created_at: Time.zone.now)
      create(:referral, user:, created_at: Time.zone.now - 1.hour)

      expect(user.latest_referral).to eq expected_referral
    end
  end
end
