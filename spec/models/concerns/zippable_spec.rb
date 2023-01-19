require "rails_helper"

describe Zippable do
  before { travel_to Time.zone.local(2022, 11, 22, 12, 0, 0) }

  describe "#zip_file_path" do
    let(:referral) { create(:referral, :with_attachments) }

    it "returns the generated file path" do
      expect(Pathname.new(referral.zip_file_path)).to be_file
    end
  end

  describe "#zip_file_name" do
    let(:referral) { create(:referral) }

    it "returns the file name" do
      expect(referral.zip_file_name).to eq(
        "20221122120000-referral-#{referral.id}.zip"
      )
    end
  end

  describe "#has_attachments?" do
    context "without attachments" do
      let(:referral) { create(:referral) }

      it "returns false" do
        expect(referral.has_attachments?).to be false
      end
    end

    context "with attachments" do
      let(:referral) { create(:referral, :with_attachments) }

      it "returns true" do
        expect(referral.has_attachments?).to be true
      end
    end
  end
end
