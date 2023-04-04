require "rails_helper"

RSpec.describe Organisation, type: :model do
  it { is_expected.to belong_to(:referral) }

  describe "#address?" do
    subject { organisation.address? }

    context "when the address fields are all present" do
      let(:organisation) do
        build(:organisation, street_1: "Street", city: "London", postcode: "AB1 2CD")
      end

      it { is_expected.to be_truthy }
    end

    context "when any of the address fields are not present" do
      let(:organisation) { build(:organisation, street_1: nil) }

      it { is_expected.to be_falsey }
    end
  end

  describe "#completed?" do
    context "when it is completed" do
      subject { build(:organisation, complete: true) }

      it { is_expected.to be_completed }
    end

    context "when complete is nil" do
      subject { build(:organisation) }

      it { is_expected.not_to be_completed }
    end
  end

  describe "#status" do
    subject { organisation.status }

    context "when complete is true" do
      let(:organisation) { build(:organisation, complete: true) }

      it { is_expected.to eq(:completed) }
    end

    context "when complete is nil" do
      let(:organisation) { build(:organisation, complete: nil) }

      it { is_expected.to eq(:incomplete) }
    end
  end
end
