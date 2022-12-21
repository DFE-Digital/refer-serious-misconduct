require "rails_helper"

RSpec.describe Referrals::TeacherRole::TeachingLocationForm, type: :model do
  let(:referral) { create(:referral) }
  let(:form) { described_class.new(params) }

  let(:params) do
    {
      teaching_organisation_name: "High School",
      teaching_address_line_1: "1428 Elm Street",
      teaching_address_line_2: "Sunset Boulevard",
      teaching_postcode: "NW1 4NP",
      referral:,
      teaching_town_or_city: "London"
    }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:referral) }
    it { is_expected.to validate_presence_of(:teaching_organisation_name) }
    it { is_expected.to validate_presence_of(:teaching_address_line_1) }
    it { is_expected.to validate_presence_of(:teaching_town_or_city) }
    it { is_expected.to validate_presence_of(:teaching_postcode) }
  end

  describe "#valid?" do
    subject(:valid) { form.valid? }

    before { valid }

    it { is_expected.to be_truthy }

    context "when teaching_organisation_name is blank" do
      let(:params) { super().merge(teaching_organisation_name: "") }

      it { is_expected.to be_falsy }

      it "adds an error" do
        expect(form.errors[:teaching_organisation_name]).to eq(
          ["Enter the organisation name"]
        )
      end
    end

    context "when teaching_address_line_1 is blank" do
      let(:params) { super().merge(teaching_address_line_1: "") }

      it { is_expected.to be_falsy }

      it "adds an error" do
        expect(form.errors[:teaching_address_line_1]).to eq(
          ["Enter the first line of the address"]
        )
      end
    end

    context "when teaching_town_or_city is blank" do
      let(:params) { super().merge(teaching_town_or_city: "") }

      it { is_expected.to be_falsy }

      it "adds an error" do
        expect(form.errors[:teaching_town_or_city]).to eq(
          ["Enter the town or city"]
        )
      end
    end

    context "when teaching_postcode is blank" do
      let(:params) { super().merge(teaching_postcode: "") }

      it { is_expected.to be_falsy }

      it "adds an error" do
        expect(form.errors[:teaching_postcode]).to eq(["Enter the postcode"])
      end
    end

    context "when teaching_postcode is invalid" do
      let(:params) { super().merge(teaching_postcode: "Invalid") }

      it { is_expected.to be_falsy }

      it "adds an error" do
        expect(form.errors[:teaching_postcode]).to eq(["Enter a real postcode"])
      end
    end
  end

  describe "#save" do
    before { form.save }

    it "saves teaching_organisation_name" do
      expect(referral.teaching_organisation_name).to eq("High School")
    end

    it "saves teaching_address_line_1" do
      expect(referral.teaching_address_line_1).to eq("1428 Elm Street")
    end

    it "saves teaching_address_line_2" do
      expect(referral.teaching_address_line_2).to eq("Sunset Boulevard")
    end

    it "saves teaching_town_or_city" do
      expect(referral.teaching_town_or_city).to eq("London")
    end

    it "saves teaching_postcode" do
      expect(referral.teaching_postcode).to eq("NW1 4NP")
    end
  end
end
