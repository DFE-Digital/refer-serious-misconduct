require "rails_helper"

RSpec.describe StaffMailer, type: :mailer do
  before do
    create(:staff, :feedback_notification, email: "yes@example.com")
    create(:staff, email: "no@example.com")
  end

  describe "#feedback_notification" do
    subject(:email) { described_class.feedback_notification }

    it "includes the required information" do
      expect(
        email.body
      ).to include "You can view feedback at http://localhost:3000/admin/feedback"
    end

    it "sets the subject" do
      expect(email.subject).to eql("New feedback received")
    end

    describe "to email address" do
      it "sets the to address to staff set to receive feedback notifications" do
        expect(email.to).to include("yes@example.com")
        expect(email.to).not_to include("no@example.com")
      end
    end

    it "sets the reply-to address to Notify's misconduct.teacher@education.gov.uk ID" do
      reply_to_field = email.header.fields.find { |field| field.name == "reply-to-id" }.value
      expect(reply_to_field).to eq "83cac27e-b914-46a3-a1f9-56e5acb07d05"
    end

    it "sets the template to Notify's `Manage Serious Misconduct Referrals` mailer ID" do
      template_id = email.header.fields.find { |field| field.name == "template-id" }.value
      expect(template_id).to eq "4f8e7de9-3987-4e75-974f-ac94068c4a62"
    end

    describe "API keys" do
      before { ActionMailer::Base.notify_settings[:api_key] = "fake_key" }

      it "uses the manage Notify API key" do
        expect { email.deliver_now }.to(
          change { ActionMailer::Base.notify_settings[:api_key] }.from("fake_key").to(
            "govuk_notify_manage_serious_misconduct_api_key"
          )
        )
      end
    end
  end
end
