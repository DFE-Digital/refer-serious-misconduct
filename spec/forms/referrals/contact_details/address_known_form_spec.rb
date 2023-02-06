require "rails_helper"

RSpec.describe Referrals::ContactDetails::AddressKnownForm, type: :model do
  it { is_expected.to validate_presence_of(:referral) }

  describe "#save" do
    subject(:save) { described_class.new(referral:, address_known:).save }

    let(:address_known) { true }
    let(:referral) { build(:referral) }

    it "saves address_known" do
      save
      expect(referral.address_known).to be_truthy
    end

    context "when the address is not known" do
      let(:address_known) { false }

      it "sets the address_known to false" do
        save
        expect(referral.address_known).to be_falsy
      end
    end
  end
end
