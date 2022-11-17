require "rails_helper"

RSpec.describe Referral, type: :model do
  it { is_expected.to have_one(:organisation).dependent(:destroy) }
  it { is_expected.to have_one(:referrer).dependent(:destroy) }

  describe "#referrer_status" do
    subject { referral.referrer_status }

    let(:referral) { build(:referral) }

    it { is_expected.to eq(:not_started_yet) }

    context "when a referrer is present" do
      let(:referral) do
        build(:referral, referrer: build(:referrer, :incomplete))
      end

      it { is_expected.to eq(:incomplete) }
    end
  end

  describe "#organisation_status" do
    subject { referral.organisation_status }

    let(:referral) { build(:referral) }

    it { is_expected.to eq(:not_started_yet) }

    context "when an organisation is present" do
      let(:referral) { build(:organisation).referral }

      it { is_expected.to eq(:incomplete) }
    end
  end

  describe "#previous_misconduct_status" do
    subject { referral.previous_misconduct_status }

    let(:referral) { build(:referral) }

    it { is_expected.to eq(:not_started_yet) }

    context "when previous_misconduct_completed_at is present" do
      let(:referral) do
        build(:referral, previous_misconduct_completed_at: Time.current)
      end

      it { is_expected.to eq(:complete) }
    end

    context "when previous_misconduct_deferred_at is present" do
      let(:referral) do
        build(:referral, previous_misconduct_deferred_at: Time.current)
      end

      it { is_expected.to eq(:incomplete) }
    end

    context "when both previous_misconduct_completed_at and previous_misconduct_deferred_at are present" do
      let(:referral) do
        build(
          :referral,
          previous_misconduct_completed_at: Time.current,
          previous_misconduct_deferred_at: Time.current
        )
      end

      it { is_expected.to eq(:complete) }
    end
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

    context "when previous_misconduct_reported is i_dont_know" do
      let(:referral) do
        build(:referral, previous_misconduct_reported: "i_dont_know")
      end

      it { is_expected.to be_falsey }
    end
  end
end
