require "rails_helper"

RSpec.describe Referral, type: :model do
  it { is_expected.to have_one(:organisation).dependent(:destroy) }
  it { is_expected.to have_one(:referrer).dependent(:destroy) }
  it { is_expected.to have_one_attached(:previous_misconduct_upload) }

  describe ".employer" do
    subject { described_class.employer }

    let(:employer_referral) { create(:referral) }
    let(:public_referral) do
      create(:referral, eligibility_check: create(:eligibility_check, :public))
    end

    it { is_expected.to eq [employer_referral] }
  end

  describe ".member_of_public" do
    subject { described_class.member_of_public }

    let(:employer_referral) { create(:referral) }
    let(:public_referral) do
      create(:referral, eligibility_check: create(:eligibility_check, :public))
    end

    it { is_expected.to eq [public_referral] }
  end

  describe "#previous_misconduct_reported?" do
    subject { referral.previous_misconduct_reported? }

    let(:referral) { build(:referral) }

    it { is_expected.to be_falsey }

    context "when previous_misconduct_reported is true" do
      let(:referral) { build(:referral, previous_misconduct_reported: "true") }

      it { is_expected.to be_truthy }
    end

    context "when previous_misconduct_reported is false" do
      let(:referral) { build(:referral, previous_misconduct_reported: "false") }

      it { is_expected.to be_falsey }
    end

    context "when previous_misconduct_reported is not_sure" do
      let(:referral) do
        build(:referral, previous_misconduct_reported: "not_sure")
      end

      it { is_expected.to be_falsey }
    end
  end

  describe "#from_employer?" do
    subject { referral.from_employer? }

    context "when eligibility_check is reporting_as_employer" do
      let(:referral) do
        build(:referral, eligibility_check: build(:eligibility_check))
      end

      it { is_expected.to be_truthy }
    end

    context "when eligibility_check is reporting_as_public" do
      let(:referral) do
        build(:referral, eligibility_check: build(:eligibility_check, :public))
      end

      it { is_expected.to be_falsey }
    end
  end

  describe "#from_member_of_public?" do
    subject { referral.from_member_of_public? }

    context "when eligibility_check is reporting_as_employer" do
      let(:referral) do
        build(:referral, eligibility_check: build(:eligibility_check))
      end

      it { is_expected.to be_falsey }
    end

    context "when eligibility_check is reporting_as_public" do
      let(:referral) do
        build(:referral, eligibility_check: build(:eligibility_check, :public))
      end

      it { is_expected.to be_truthy }
    end
  end
end
