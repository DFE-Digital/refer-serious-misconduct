# frozen_string_literal: true
require "rails_helper"

RSpec.describe Referrals::AllegationDetails::DetailsForm, type: :model do
  let(:referral) { create(:referral) }

  describe "#save" do
    subject(:save) { form.save }

    let(:allegation_details) { nil }
    let(:allegation_upload_file) { nil }
    let(:form) do
      described_class.new(
        referral:,
        allegation_details:,
        allegation_format:,
        allegation_upload_file:
      )
    end

    context "with no allegation format" do
      let(:allegation_format) { nil }

      before { save }

      it { is_expected.to be_falsy }

      it "adds an error" do
        expect(form.errors[:allegation_format]).to eq(
          ["Select how you want to give details about the allegation"]
        )
      end
    end

    context "with upload format but no file" do
      let(:allegation_format) { "upload" }

      before { save }

      it { is_expected.to be_falsy }

      it "adds an error" do
        expect(form.errors[:allegation_upload_file]).to eq(
          ["Select a file containing details of your allegation"]
        )
      end
    end

    context "with upload format and file" do
      let(:allegation_format) { "upload" }
      let(:allegation_upload_file) { fixture_file_upload("upload1.pdf") }
      let(:referral) { create(:referral, allegation_details: "Old details") }

      before do
        referral.uploads.create(section: "allegation", file: allegation_upload_file)
        save
      end

      it { is_expected.to be_truthy }

      it "associates the upload with the referral" do
        expect(referral.allegation_upload_file).to be_attached
      end

      it "clears the allegation details" do
        expect(referral.allegation_details).to be_nil
      end
    end

    context "with upload format and invalid file" do
      let(:allegation_format) { "upload" }
      let(:allegation_upload_file) { fixture_file_upload("upload.pl") }

      it "returns false" do
        expect(save).to be false
      end

      it "adds an error" do
        save
        expect(form.errors[:allegation_upload_file]).to eq(
          [
            "The selected file must be of type (#{FileUploadValidator::CONTENT_TYPES.keys.sort.join(", ")})"
          ]
        )
      end
    end

    context "with details format and no details" do
      let(:allegation_format) { "details" }

      before { save }

      it { is_expected.to be_falsy }

      it "adds an error" do
        expect(form.errors[:allegation_details]).to eq(["Enter details of the allegation"])
      end
    end

    context "with details format and details" do
      let(:allegation_format) { "details" }
      let(:allegation_details) { "Something something" }
      let(:allegation_upload_file) { fixture_file_upload("upload.pl") }

      before do
        referral.uploads.create!(section: "allegation", file: allegation_upload_file)
        save
      end

      it { is_expected.to be_truthy }

      it "updates details on the referral" do
        expect(referral.allegation_details).to eq("Something something")
      end

      it "removes the previous upload from the referral" do
        expect(referral.allegation_upload_file).to be_nil
      end
    end
  end
end
