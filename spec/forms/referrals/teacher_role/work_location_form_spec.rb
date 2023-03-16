require "rails_helper"

RSpec.describe Referrals::TeacherRole::WorkLocationForm, type: :model do
  let(:referral) { create(:referral) }
  let(:form) { described_class.new(params) }

  let(:params) do
    {
      work_organisation_name: "High School",
      work_address_line_1: "1428 Elm Street",
      work_address_line_2: "Sunset Boulevard",
      work_postcode: "NW1 4NP",
      referral:,
      work_town_or_city: "London"
    }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:referral) }
    it { is_expected.to validate_presence_of(:work_organisation_name) }
    it { is_expected.to validate_presence_of(:work_address_line_1) }
    it { is_expected.to validate_presence_of(:work_town_or_city) }
    it { is_expected.to validate_presence_of(:work_postcode) }
  end

  describe "#valid?" do
    subject(:valid) { form.valid? }

    before { valid }

    it { is_expected.to be_truthy }

    context "when work_organisation_name is blank" do
      let(:params) { super().merge(work_organisation_name: "") }

      it { is_expected.to be_falsy }

      it "adds an error" do
        expect(form.errors[:work_organisation_name]).to eq(["Enter the organisation name"])
      end
    end

    context "when work_address_line_1 is blank" do
      let(:params) { super().merge(work_address_line_1: "") }

      it { is_expected.to be_falsy }

      it "adds an error" do
        expect(form.errors[:work_address_line_1]).to eq(["Enter the first line of the address"])
      end
    end

    context "when work_town_or_city is blank" do
      let(:params) { super().merge(work_town_or_city: "") }

      it { is_expected.to be_falsy }

      it "adds an error" do
        expect(form.errors[:work_town_or_city]).to eq(["Enter the town or city"])
      end
    end

    context "when work_postcode is blank" do
      let(:params) { super().merge(work_postcode: "") }

      it { is_expected.to be_falsy }

      it "adds an error" do
        expect(form.errors[:work_postcode]).to eq(["Enter the postcode"])
      end
    end

    context "when work_postcode is invalid" do
      let(:params) { super().merge(work_postcode: "Invalid") }

      it { is_expected.to be_falsy }

      it "adds an error" do
        expect(form.errors[:work_postcode]).to eq(["Enter a real postcode"])
      end
    end
  end

  describe "#save" do
    before { form.save }

    it "saves work_organisation_name" do
      expect(referral.work_organisation_name).to eq("High School")
    end

    it "saves work_address_line_1" do
      expect(referral.work_address_line_1).to eq("1428 Elm Street")
    end

    it "saves work_address_line_2" do
      expect(referral.work_address_line_2).to eq("Sunset Boulevard")
    end

    it "saves work_town_or_city" do
      expect(referral.work_town_or_city).to eq("London")
    end

    it "saves work_postcode" do
      expect(referral.work_postcode).to eq("NW1 4NP")
    end
  end
end
