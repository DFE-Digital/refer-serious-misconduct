# frozen_string_literal: true
require "rails_helper"

RSpec.describe Referrals::Allegation::DbsForm, type: :model do
  let(:referral) { build(:referral) }

  describe "#save" do
    let(:dbs_notified) { nil }
    let(:form) { described_class.new(referral:, dbs_notified:) }

    subject(:save) { form.save }

    context "with no answer" do
      it "returns false and adds an error" do
        expect(save).to be false
        expect(form.errors[:dbs_notified]).to eq(
          ["Tell us if you have notified DBS about the case"]
        )
      end
    end

    context "with an answer" do
      let(:dbs_notified) { "true" }
      it "returns true" do
        expect(save).to be true
      end

      it "saves the answer on the referral" do
        save
        expect(referral.dbs_notified).to be true
      end
    end
  end
end
