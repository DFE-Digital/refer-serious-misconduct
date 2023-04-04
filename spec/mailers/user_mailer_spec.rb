require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe ".otp" do
    subject(:email) { described_class.otp(user) }

    let(:secret_key) { Devise::Otp.generate_key }
    let(:user) { build(:user, secret_key:) }
    let(:otp) { Devise::Otp.derive_otp(secret_key) }

    it "sends a one-time password to the user" do
      expect(email.to).to include user.email
    end

    it "includes the one-time password in the email body" do
      expect(email.body).to include(otp)
    end

    it "sets the subject" do
      expect(email.subject).to eq "#{otp} is your confirmation code"
    end

    it_behaves_like "email with `Get help` section"
  end

  describe ".referral_link" do
    subject(:email) { described_class.referral_link(referral) }

    let(:user) { create(:user) }
    let(:referral) { create(:referral, user_id: user.id) }

    it "sends a referral link to the user" do
      expect(email.to).to include user.email
    end

    it "includes the referral link in the email body" do
      expect(email.body).to include(edit_referral_url(referral))
    end

    it "sets the subject" do
      expect(email.subject).to eq "Your referral of serious misconduct by a teacher"
    end

    it_behaves_like "email with `Get help` section"
  end

  describe ".referral_submitted" do
    subject(:email) { described_class.referral_submitted(referral) }

    let(:user) { create(:user) }
    let(:referral) { create(:referral, :submitted, user_id: user.id) }

    it "sends a referral link to the user" do
      expect(email.to).to include user.email
    end

    it "includes the referral link in the email body" do
      expect(email.body).to include(users_referral_url(referral))
    end

    it "sets the subject" do
      expect(email.subject).to eq "Your referral of serious misconduct has been sent"
    end

    it_behaves_like "email with `Get help` section"

    describe "API keys" do
      before { ActionMailer::Base.notify_settings[:api_key] = "fake_key" }

      it "uses the TRA Notify API key" do
        expect { email.deliver_now }.to(
          change { ActionMailer::Base.notify_settings[:api_key] }.from("fake_key").to(
            "govuk_notify_api_key"
          )
        )
      end
    end
  end

  describe ".draft_referral_reminder" do
    subject(:email) { described_class.draft_referral_reminder(referral) }

    let(:user) { create(:user) }
    let(:referral) { create(:referral, user_id: user.id) }

    it "sends a referral link to the user" do
      expect(email.to).to include user.email
    end

    it "includes the referral link in the email body" do
      expect(email.body).to include(edit_referral_url(referral))
    end

    it "includes the correct deletion date" do
      expect(email.body).to include(7.days.from_now.strftime("%d %B %Y"))
    end

    it "sets the subject" do
      expect(email.subject).to eq "Your referral will be deleted in 7 days"
    end

    it_behaves_like "email with `Get help` section"
  end
end
