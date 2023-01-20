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
      expect(referral_zip_file.name).to eq(
        "20221122120000-referral-#{referral.id}.zip"
      )
    end
  end
end
