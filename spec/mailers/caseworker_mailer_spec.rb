require "rails_helper"

RSpec.describe CaseworkerMailer, type: :mailer do
  describe ".referral_submitted" do
    subject(:email) { described_class.referral_submitted(referral) }

    let(:referral) { create(:referral, :personal_details_public, :submitted) }

    it "includes the required information" do
      expect(
        email.body
      ).to include "John Smith has been referred for serious misconduct by a teacher"
    end

    it "includes the manage referral URL" do
      expect(email.body).to include "/manage/referrals/#{referral.id}"
    end

    it "sets the subject" do
      expect(email.subject).to eq "John Smith has been referred"
    end

    describe "to email address" do
      context "when the GOVUK_NOTIFY_MISCONDUCT_TEACHER_EMAIL is set" do
        before do
          allow(ENV).to receive(:[]).with(
            "GOVUK_NOTIFY_MISCONDUCT_TEACHER_EMAIL"
          ).and_return("test@example.com")
        end

        it "sets the to address to the GOVUK_NOTIFY_MISCONDUCT_TEACHER_EMAIL" do
          expect(email.to).to eq ["test@example.com"]
        end
      end

      context "when the GOVUK_NOTIFY_MISCONDUCT_TEACHER_EMAIL is not set" do
        before do
          allow(ENV).to receive(:[]).with(
            "GOVUK_NOTIFY_MISCONDUCT_TEACHER_EMAIL"
          ).and_return(nil)
        end

        it "sets the to address to misconduct.teacher@education.gov.uk" do
          expect(email.to).to eq ["misconduct.teacher@education.gov.uk"]
        end
      end
    end

    it "sets the reply-to address to Notify's misconduct.teacher@education.gov.uk ID" do
      reply_to_field =
        email.header.fields.find { |field| field.name == "reply-to-id" }.value
      expect(reply_to_field).to eq "83cac27e-b914-46a3-a1f9-56e5acb07d05"
    end

    it "sets the template to Notify's `Manage Serious Misconduct Referrals` mailer ID" do
      template_id =
        email.header.fields.find { |field| field.name == "template-id" }.value
      expect(template_id).to eq "4f8e7de9-3987-4e75-974f-ac94068c4a62"
    end

    describe "API keys" do
      before { ActionMailer::Base.notify_settings[:api_key] = "fake_key" }

      it "uses the manage Notify API key" do
        expect { email.deliver_now }.to(
          change { ActionMailer::Base.notify_settings[:api_key] }.from(
            "fake_key"
          ).to("govuk_notify_manage_serious_misconduct_api_key")
        )
      end
    end
  end
end
