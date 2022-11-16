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
end
