require "rails_helper"

RSpec.describe OrganisationNameForm, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:referral) }
  end

  describe "#valid?" do
    subject(:valid) { form.valid? }

    let(:referral) { build(:referral) }
    let(:form) { described_class.new(referral:, name:) }
    let(:name) { "Name" }

    it { is_expected.to be_truthy }

    context "when name is blank" do
      let(:name) { "" }

      it { is_expected.to be_falsy }
    end
  end

  describe "#save" do
    subject(:save) { form.save }

    let(:name) { "Name" }
    let(:organisation) { build(:organisation) }
    let(:referral) { organisation.referral }
    let(:form) { described_class.new(referral:, name:) }

    it "saves the Referral" do
      save
      expect(organisation.name).to eq("Name")
    end
  end
end
