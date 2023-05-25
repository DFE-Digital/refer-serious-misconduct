require "rails_helper"

RSpec.describe Referrals::TeacherContactDetails::CheckAnswersForm, type: :model do
  let(:referral) { create(:referral) }
  let(:form) { described_class.new(referral:, contact_details_complete:) }
  let(:contact_details_complete) { true }

  describe "validations" do
    it { is_expected.to validate_presence_of(:referral) }
  end

  describe "#valid?" do
    subject(:valid) { form.valid? }

    before { valid }

    it { is_expected.to be_truthy }

    context "when contact_details_complete is blank" do
      let(:contact_details_complete) { "" }

      it { is_expected.to be_falsy }

      it "adds an error" do
        expect(form.errors[:contact_details_complete]).to eq(
          ["Select yes if you’ve completed this section"]
        )
      end
    end
  end

  describe "#save" do
    before { form.save }

    it "saves contact_details_complete" do
      expect(referral.contact_details_complete).to be_truthy
    end

    context "when the form is marked as in progress" do
      let(:contact_details_complete) { false }

      it "saves contact_details_complete as false" do
        expect(referral.contact_details_complete).to be_falsy
      end
    end
  end
end
