require "rails_helper"

RSpec.describe Referrals::TeacherRole::OrganisationAddressForm, type: :model do
  let(:referral) { create(:referral) }
  let(:form) { described_class.new(params) }

  let(:params) do
    {
      organisation_name: "DfE",
      organisation_address_line_1: "1428 Elm Street",
      organisation_address_line_2: "Sunset Boulevard",
      organisation_postcode: "NW1 4NP",
      referral:,
      organisation_town_or_city: "London"
    }
  end

  describe "validations" do
    subject { form }

    it { is_expected.to validate_presence_of(:referral) }
    it { is_expected.to validate_presence_of(:organisation_name) }
    it { is_expected.to validate_presence_of(:organisation_address_line_1) }
    it { is_expected.to validate_presence_of(:organisation_town_or_city) }
    it { is_expected.to validate_presence_of(:organisation_postcode) }
  end

  describe "#valid?" do
    subject(:valid) { form.valid? }

    before { valid }

    it { is_expected.to be_truthy }

    context "when organisation_name is blank" do
      let(:params) { super().merge(organisation_name: "") }

      it { is_expected.to be_falsy }

      it "adds an error" do
        expect(form.errors[:organisation_name]).to eq(
          ["Enter the organisation name"]
        )
      end
    end

    context "when organisation_address_line_1 is blank" do
      let(:params) { super().merge(organisation_address_line_1: "") }

      it { is_expected.to be_falsy }

      it "adds an error" do
        expect(form.errors[:organisation_address_line_1]).to eq(
          ["Enter the first line of the organisation's address"]
        )
      end
    end

    context "when organisation_town_or_city is blank" do
      let(:params) { super().merge(organisation_town_or_city: "") }

      it { is_expected.to be_falsy }

      it "adds an error" do
        expect(form.errors[:organisation_town_or_city]).to eq(
          ["Enter a town or city for the organisation"]
        )
      end
    end

    context "when organisation_postcode is blank" do
      let(:params) { super().merge(organisation_postcode: "") }

      it { is_expected.to be_falsy }

      it "adds an error" do
        expect(form.errors[:organisation_postcode]).to eq(
          ["Enter a postcode for the organisation"]
        )
      end
    end

    context "when organisation_postcode is invalid" do
      let(:params) { super().merge(organisation_postcode: "Invalid") }

      it { is_expected.to be_falsy }

      it "adds an error" do
        expect(form.errors[:organisation_postcode]).to eq(
          ["Enter a real postcode"]
        )
      end
    end
  end

  describe "#save" do
    before { form.save }

    it "saves organisation_name" do
      expect(referral.organisation_name).to eq("DfE")
    end

    it "saves organisation_address_line_1" do
      expect(referral.organisation_address_line_1).to eq("1428 Elm Street")
    end

    it "saves organisation_address_line_2" do
      expect(referral.organisation_address_line_2).to eq("Sunset Boulevard")
    end

    it "saves organisation_town_or_city" do
      expect(referral.organisation_town_or_city).to eq("London")
    end

    it "saves organisation_postcode" do
      expect(referral.organisation_postcode).to eq("NW1 4NP")
    end
  end
end
