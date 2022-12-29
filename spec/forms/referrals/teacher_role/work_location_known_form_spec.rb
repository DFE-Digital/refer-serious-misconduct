require "rails_helper"

RSpec.describe Referrals::TeacherRole::WorkLocationKnownForm, type: :model do
  let(:referral) { create(:referral) }
  let(:work_location_known) { true }
  let(:form) { described_class.new(referral:, work_location_known:) }

  describe "validations" do
    it { is_expected.to validate_presence_of(:referral) }

    it do
      expect(form).to validate_presence_of(:work_location_known).with_message(
        "Select yes if you know the name and address of the organisation where they’re currently working"
      )
    end
  end

  describe "#valid?" do
    subject(:valid) { form.valid? }

    before { valid }

    it { is_expected.to be_truthy }

    context "when work_location_known is blank" do
      let(:work_location_known) { "" }

      it { is_expected.to be_falsy }

      it "adds an error" do
        expect(form.errors[:work_location_known]).to eq(
          [
            "Select yes if you know the name and address of the organisation where they’re currently working"
          ]
        )
      end
    end
  end

  describe "#save" do
    before { form.save }

    it "saves work_location_known" do
      expect(referral.work_location_known).to be_truthy
    end

    context "when the address is not known" do
      let(:work_location_known) { false }

      it "sets the work_location_known to false" do
        expect(referral.work_location_known).to be_falsy
      end
    end
  end
end
