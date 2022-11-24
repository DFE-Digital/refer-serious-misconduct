# frozen_string_literal: true
require "rails_helper"

RSpec.describe Referrals::Allegation::DetailsForm, type: :model do
  let(:referral) { build(:referral) }

  describe "#save" do
    let(:allegation_format) { nil }
    let(:allegation_details) { nil }
    let(:allegation_upload) { nil }
    let(:form) do
      described_class.new(
        referral:,
        allegation_details:,
        allegation_format:,
        allegation_upload:
      )
    end

    subject(:save) { form.save }

    context "with no allegation format" do
      it "returns false" do
        expect(save).to be false
      end

      it "adds an error" do
        save
        expect(form.errors[:allegation_format]).to eq(
          ["Choose how you want to tell us about your allegation"]
        )
      end
    end

    context "with upload format but no file" do
      let(:allegation_format) { "upload" }
      it "returns false" do
        expect(save).to be false
      end

      it "adds an error" do
        save
        expect(form.errors[:allegation_upload]).to eq(
          ["Select a file containing details of your allegation"]
        )
      end
    end

    context "with upload format and file" do
      let(:allegation_format) { "upload" }
      let(:allegation_upload) { fixture_file_upload("upload.pdf") }

      it "returns true" do
        expect(save).to be true
      end

      it "associates the upload with the referral" do
        save
        expect(referral.allegation_upload).to be_attached
        expect(referral.allegation_details).to be nil
      end
    end

    context "with upload format and invalid file" do
      let(:allegation_format) { "upload" }
      let(:allegation_upload) { fixture_file_upload("upload.pl") }

      it "returns false" do
        expect(save).to be false
      end

      it "adds an error" do
        save
        expect(form.errors[:allegation_upload]).to eq(
          ["Please upload a valid file type (.doc, .docx, .pdf, .txt)"]
        )
      end
    end

    context "with details format and no details" do
      let(:allegation_format) { "details" }

      it "returns false" do
        expect(save).to be false
      end

      it "adds an error" do
        save
        expect(form.errors[:allegation_details]).to eq(
          ["Enter details of the allegation"]
        )
      end
    end

    context "with details format and details" do
      let(:allegation_format) { "details" }
      let(:allegation_details) { "Something something" }

      it "returns true" do
        expect(save).to be true
      end

      it "updates details on the referral" do
        save
        expect(referral.reload.allegation_details).to eq("Something something")
        expect(referral.allegation_upload).not_to be_attached
      end

      it "purges the allegation upload on the referral" do
        referral.allegation_upload.attach(
          Rack::Test::UploadedFile.new(Tempfile.new)
        )
        expect(referral.allegation_upload).to be_attached

        save
        expect(referral.reload.allegation_details).to eq("Something something")
        expect(referral.allegation_upload).not_to be_attached
      end
    end

    context "not yet complete" do
      let(:allegation_format) { "incomplete" }

      it "returns true" do
        expect(save).to be true
      end
    end
  end
end
