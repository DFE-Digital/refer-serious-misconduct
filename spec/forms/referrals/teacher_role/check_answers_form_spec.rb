require "rails_helper"

RSpec.describe Referrals::TeacherRole::CheckAnswersForm, type: :model do
  let(:referral) { create(:referral) }
  let(:form) { described_class.new(referral:, teacher_role_complete:) }
  let(:teacher_role_complete) { true }

  describe "validations" do
    it { is_expected.to validate_presence_of(:referral) }
  end

  describe "#valid?" do
    subject(:valid) { form.valid? }

    before { valid }

    it { is_expected.to be_truthy }

    context "when teacher_role_complete is blank" do
      let(:teacher_role_complete) { "" }

      it { is_expected.to be_falsy }

      it "adds an error" do
        expect(form.errors[:teacher_role_complete]).to eq(
          ["Tell us if you have completed this section"]
        )
      end
    end
  end

  describe "#save" do
    before { form.save }

    it "saves teacher_role_complete" do
      expect(referral.teacher_role_complete).to be_truthy
    end

    context "when the form is marked as in progress" do
      let(:teacher_role_complete) { false }

      it "saves teacher_role_complete as false" do
        expect(referral.teacher_role_complete).to be_falsy
      end
    end
  end
end
