# frozen_string_literal: true
require "rails_helper"

RSpec.describe Referrals::AllegationEvidence::UploadForm, type: :model do
  describe "#save" do
    subject(:save) { upload_form.save }

    let(:referral) { create(:referral) }
    let(:upload_form) { described_class.new(referral:, evidence_uploads:) }
    let(:evidence_uploads) do
      [
        "",
        fixture_file_upload("spec/fixtures/files/upload1.pdf"),
        fixture_file_upload("spec/fixtures/files/upload2.pdf")
      ]
    end

    before do
      save
      referral.reload
    end

    it "saves all uploaded files" do
      expect(referral.evidence_uploads.count).to eq(2)
    end

    it "creates an Upload" do
      expect(referral.evidence_uploads.first).to be_a(Upload)
    end

    it "attaches the evidence" do
      expect(referral.evidence_uploads.first.file).to be_attached
    end

    it "sets the correct filename" do
      expect(referral.evidence_uploads.first.filename).to eq("upload1.pdf")
    end

    context "with no values" do
      let(:evidence_uploads) { nil }

      it "adds an error" do
        expect(upload_form.errors[:evidence_uploads]).to eq(["Select evidence to upload"])
      end
    end

    context "with an invalid file" do
      let(:evidence_uploads) { [fixture_file_upload("upload.pl")] }

      it "adds an error" do
        expect(upload_form.errors[:evidence_uploads]).to eq(
          [
            "The selected file must be of valid type (#{FileUploadValidator::CONTENT_TYPES.keys.sort.join(", ")})"
          ]
        )
      end
    end

    context "with multiple uploads" do
      it "appends to existing referral evidence" do
        upload_form.evidence_uploads = [fixture_file_upload("upload.txt")]
        expect { upload_form.save }.to change(referral.evidence_uploads, :size).by(1)
        expect(referral.evidence_uploads.size).to eq(3)
        expect(referral.evidence_uploads.map(&:filename)).to eq(
          %w[upload1.pdf upload2.pdf upload.txt]
        )
      end

      it "validates that the maximum number of files is not exceeded" do
        upload_form.evidence_uploads = (described_class::MAX_FILES - 1).times.map do
          fixture_file_upload("upload.txt")
        end
        expect(upload_form.save).to be false
        expect(upload_form.errors[:evidence_uploads]).to eq(["You can only upload 20 files"])
      end
    end
  end
end
