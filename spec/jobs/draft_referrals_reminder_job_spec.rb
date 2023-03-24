require "rails_helper"

RSpec.describe DraftReferralsReminderJob, type: :job do
  let!(:referral_to_remind) { create(:referral, updated_at: 83.days.ago) }

  before do
    create_list(:referral, 2)
    create_list(:referral, 2, :submitted, updated_at: 83.days.ago)
  end

  describe "running the job" do
    subject(:perform) { described_class.new.perform }

    context "when the send_reminder_email feature is active" do
      before { FeatureFlags::FeatureFlag.activate(:send_reminder_email) }

      it "enqueues 1 job" do
        expect { perform }.to(have_enqueued_job(SendReminderEmailJob).once)
      end

      context "when the referral has reminder sent more than 8 days ago" do
        before { create(:reminder_email, referral: referral_to_remind, created_at: 9.days.ago) }

        after { ReminderEmail.destroy_all }

        it "enqueues 1 jobs" do
          expect { perform }.to(have_enqueued_job(SendReminderEmailJob).once)
        end
      end

      context "when the referral has reminder sent less than 8 days ago" do
        before { create(:reminder_email, referral: referral_to_remind) }

        after { ReminderEmail.destroy_all }

        it "enqueues 0 jobs" do
          expect { perform }.not_to(have_enqueued_job(SendReminderEmailJob))
        end
      end

      context "when reminders were sent 90 days ago and less than 8 days ago" do
        before do
          create(:reminder_email, referral: referral_to_remind, created_at: 90.days.ago)
          create(:reminder_email, referral: referral_to_remind)
        end

        after { ReminderEmail.destroy_all }

        it "enqueues 2 jobs" do
          expect { perform }.not_to(have_enqueued_job(SendReminderEmailJob))
        end
      end
    end

    context "when the send_reminder_email feature is not active" do
      before { FeatureFlags::FeatureFlag.deactivate(:send_reminder_email) }

      it "enqueues 0 jobs" do
        expect { perform }.not_to(have_enqueued_job(SendReminderEmailJob))
      end
    end
  end
end
