# frozen_string_literal: true
require "rails_helper"

RSpec.describe Referrals::AllegationDetails::DbsForm, type: :model do
  let(:referral) { build(:referral) }

  describe "#save" do
    subject(:save) { form.save }

    let(:form) { described_class.new(referral:, dbs_notified:) }

    context "with no answer" do
      let(:dbs_notified) { nil }

      it { is_expected.to be_falsy }

      it "adds an error" do
        save
        expect(form.errors[:dbs_notified]).to eq(["Select yes if you’ve told DBS about this case"])
      end
    end

    context "with an answer" do
      let(:dbs_notified) { "true" }

      it { is_expected.to be_truthy }

      it "saves the answer on the referral" do
        save
        expect(referral.dbs_notified).to be true
      end
    end
  end
end
