# frozen_string_literal: true
require "rails_helper"

RSpec.describe Referrals::Evidence::UploadForm, type: :model do
  describe "#save" do
    subject(:save) { upload_form.save }

    let(:referral) { create(:referral) }
    let(:upload_form) { described_class.new(referral:, evidence_uploads:) }
    let(:evidence_uploads) do
      ["", fixture_file_upload("doc2.pdf"), fixture_file_upload("doc1.pdf")]
    end

    before { save }

    it "saves all uploaded files" do
      expect(referral.reload.evidences.count).to eq(2)
    end

    it "creates a ReferralEvidence" do
      expect(referral.evidences.first).to be_a(ReferralEvidence)
    end

    it "attaches the evidence" do
      expect(referral.evidences.first.document).to be_attached
    end

    it "doesn't set a default category" do
      expect(referral.evidences.first.categories).to eq([])
    end

    it "sets the correct filename" do
      expect(referral.evidences.first.filename).to eq("doc1.pdf")
    end

    context "with no values" do
      let(:evidence_uploads) { nil }

      it "adds an error" do
        expect(upload_form.errors[:evidence_uploads]).to eq(
          ["Select evidence to upload"]
        )
      end
    end

    context "with an invalid file" do
      let(:evidence_uploads) { [fixture_file_upload("upload.pl")] }

      it "adds an error" do
        expect(upload_form.errors[:evidence_uploads]).to eq(
          [
            "Please upload files of valid type (#{FileUploadValidator::CONTENT_TYPES.keys.sort.join(", ")})"
          ]
        )
      end
    end

    context "with multiple uploads" do
      it "appends to existing referral evidence" do
        upload_form.evidence_uploads = [fixture_file_upload("upload.pdf")]
        expect { upload_form.save }.to change(referral.evidences, :size).by(1)
        expect(referral.evidences.size).to eq(3)
        expect(referral.evidences.map(&:filename)).to eq(
          %w[doc1.pdf doc2.pdf upload.pdf]
        )
      end

      it "validates that the maximum number of files is not exceeded" do
        upload_form.evidence_uploads = [
          fixture_file_upload("upload.pdf"),
          fixture_file_upload("upload.pdf"),
          fixture_file_upload("upload.pdf"),
          fixture_file_upload("upload.pdf"),
          fixture_file_upload("upload.pdf"),
          fixture_file_upload("upload.pdf"),
          fixture_file_upload("upload.pdf"),
          fixture_file_upload("upload.pdf"),
          fixture_file_upload("upload.pdf")
        ]
        expect(upload_form.save).to be false
        expect(upload_form.errors[:evidence_uploads]).to eq(
          ["You can only upload 10 files in total"]
        )
      end
    end
  end
end
