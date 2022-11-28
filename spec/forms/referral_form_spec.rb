require "rails_helper"

RSpec.describe ReferralForm do
  describe "save" do
    subject(:save) { form.save }

    let(:form) { described_class.new(referral:) }
    let(:referral) { create(:referral) }

    it { is_expected.to be_falsy }

    context "when statuses are all complete" do
      let(:referral) { create(:referral, :complete) }

      it { is_expected.to be_truthy }
    end
  end
end
