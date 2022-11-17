# frozen_string_literal: true
require "rails_helper"

RSpec.describe Referrals::Evidence::UploadForm, type: :model do
  describe "#save" do
    let(:referral) { create(:referral) }
    let(:evidence_uploads) do
      [
        "",
        Rack::Test::UploadedFile.new(Rails.root.join("test/fixtures/files/doc2.pdf")),
        Rack::Test::UploadedFile.new(Rails.root.join("test/fixtures/files/doc1.pdf")),
      ]
    end

    subject(:save) { upload_form.save }

    let(:upload_form) { described_class.new(referral:, evidence_uploads:) }

    context "with a valid value" do
      it "saves the value on the referral" do
        expect { save }.to change(referral.reload.evidences, :count).by(2)

        expect(referral.evidences.first).to be_a(ReferralEvidence)
        expect(referral.evidences.first.document).to be_attached
        expect(referral.evidences.first.categories).to eq([])
        expect(referral.evidences.first.filename).to eq("doc1.pdf")

        expect(referral.evidences.last).to be_a(ReferralEvidence)
        expect(referral.evidences.last.document).to be_attached
        expect(referral.evidences.last.categories).to eq([])
        expect(referral.evidences.last.filename).to eq("doc2.pdf")
      end
    end

    context "with no values" do
      let(:evidence_uploads) { nil }
      it "adds an error" do
        save
        expect(upload_form.errors[:evidence_uploads]).to eq(
          ["Select evidence to upload"]
        )
      end
    end
  end
end
