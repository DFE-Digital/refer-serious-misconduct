require "rails_helper"

RSpec.describe Staff, type: :model do
  describe "validations" do
    subject { staff.valid? }

    context "when the password is valid" do
      let(:staff) { build(:staff, password: "Password123!") }

      it { is_expected.to be_truthy }
    end

    context "when the password is invalid" do
      context "when the password is too short" do
        let(:staff) { build(:staff, password: "password") }

        it { is_expected.to be_falsey }
      end

      context "when the password does not contain an uppercase letter" do
        let(:staff) { build(:staff, password: "password123!") }

        it { is_expected.to be_falsey }
      end

      context "when the password does not contain a lowercase letter" do
        let(:staff) { build(:staff, password: "PASSWORD123!") }

        it { is_expected.to be_falsey }
      end

      context "when the password does not contain a digit" do
        let(:staff) { build(:staff, password: "Password!") }

        it { is_expected.to be_falsey }
      end

      context "when the password does not contain a special character" do
        let(:staff) { build(:staff, password: "Password123") }

        it { is_expected.to be_falsey }
      end
    end

    context "when the email address is already taken" do
      before { create(:staff) }

      let(:staff) { build(:staff) }

      it { is_expected.to be_falsey }
    end

    context "when the permissions are invalid" do
      let(:staff) { build(:staff, view_support: nil, manage_referrals: nil) }

      it { is_expected.to be_falsey }
    end
  end

  describe "#archive" do
    let(:staff) { create(:staff) }

    it "marks the user as deleted" do
      staff.archive

      expect(staff.deleted_at).to be_within(1).of(Time.zone.now)
    end
  end
end
