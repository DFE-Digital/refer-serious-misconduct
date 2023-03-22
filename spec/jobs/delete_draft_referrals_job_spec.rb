require "rails_helper"

RSpec.describe DeleteDraftReferralsJob, type: :job do
  before do
    create_list(:referral, 3, created_at: 91.days.ago)
    create_list(:referral, 2)
    create_list(:referral, 2, :submitted, created_at: 91.days.ago)
  end

  describe "running the job" do
    subject(:perform) { described_class.new.perform }

    it "creates the Sidekiq jobs and deletes the referrals" do
      perform
      expect { perform_enqueued_jobs }.to change(Referral, :count).by(-3)
    end
  end
end
