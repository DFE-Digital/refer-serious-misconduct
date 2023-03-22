require "rails_helper"

RSpec.describe DeleteReferralJob, type: :job do
  before { create(:referral) }

  describe "running the job" do
    subject(:perform) { described_class.new.perform(Referral.first.id) }

    it "creates the Sidekiq jobs and deletes the referrals" do
      expect { perform }.to change(Referral, :count).by(-1)
    end
  end
end
