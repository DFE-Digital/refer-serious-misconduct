require "rails_helper"

describe ReferralZipFile do
  let(:referral_zip_file) { described_class.new(referral) }

  before { travel_to Time.zone.local(2022, 11, 22, 12, 0, 0) }

  describe "#path" do
    let(:referral) { create(:referral, :with_attachments) }

    it "returns the generated file path" do
      expect(Pathname.new(referral_zip_file.path)).to be_file
    end
  end

  describe "#name" do
    let(:referral) { create(:referral) }

    it "returns the file name" do
      expect(referral_zip_file.name).to eq("20221122120000-referral-#{referral.id}.zip")
    end
  end

  describe "#has_attachments?" do
    context "when the referral doesn't have attached files" do
      let(:referral) { create(:referral) }

      it "returns false" do
        expect(referral_zip_file).not_to have_attachments
      end
    end

    context "when the referral has attached files" do
      let(:referral) { create(:referral, :with_attachments) }

      it "returns true" do
        expect(referral_zip_file).to have_attachments
      end
    end

    context "when the referral has a pdf attachment" do
      let(:referral) { create(:referral, :with_pdf) }

      it "returns true" do
        expect(referral_zip_file).to have_attachments
      end
    end

    context "with suspect attachment" do
      let(:referral) { create(:referral, :with_suspect_attachment) }

      it "returns false" do
        expect(referral_zip_file).not_to have_attachments
      end
    end

    context "with pending attachment" do
      let(:referral) { create(:referral, :with_pending_attachment) }

      it "returns false" do
        expect(referral_zip_file).not_to have_attachments
      end
    end
  end
end
