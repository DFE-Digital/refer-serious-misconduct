require "rails_helper"

RSpec.describe Referrals::TeacherRole::WorkingLocationKnownForm, type: :model do
  let(:referral) { create(:referral) }
  let(:working_location_known) { true }
  let(:form) { described_class.new(referral:, working_location_known:) }

  describe "validations" do
    it { is_expected.to validate_presence_of(:referral) }

    it do
      expect(form).to validate_presence_of(
        :working_location_known
      ).with_message(
        "Select yes if you know the name and address of the organisation where they’re currently working"
      )
    end
  end

  describe "#valid?" do
    subject(:valid) { form.valid? }

    before { valid }

    it { is_expected.to be_truthy }

    context "when working_location_known is blank" do
      let(:working_location_known) { "" }

      it { is_expected.to be_falsy }

      it "adds an error" do
        expect(form.errors[:working_location_known]).to eq(
          [
            "Select yes if you know the name and address of the organisation where they’re currently working"
          ]
        )
      end
    end
  end

  describe "#save" do
    before { form.save }

    it "saves working_location_known" do
      expect(referral.working_location_known).to be_truthy
    end

    context "when the address is not known" do
      let(:working_location_known) { false }

      it "sets the working_location_known to false" do
        expect(referral.working_location_known).to be_falsy
      end
    end
  end
end
