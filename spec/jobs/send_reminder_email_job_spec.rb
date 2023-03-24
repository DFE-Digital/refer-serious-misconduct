require "rails_helper"

RSpec.describe SendReminderEmailJob, type: :job do
  before { create(:referral) }

  describe "running the job" do
    subject(:perform) { described_class.new.perform(Referral.first) }

    it "creates the Sidekiq jobs and sends the reminder email" do
      expect { perform }.to have_enqueued_mail(UserMailer, :draft_referral_reminder).once.and change(
                   ReminderEmail,
                   :count
                 ).by(1)
    end
  end
end
