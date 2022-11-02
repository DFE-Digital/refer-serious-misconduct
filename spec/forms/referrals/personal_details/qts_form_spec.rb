# frozen_string_literal: true
require "rails_helper"

RSpec.describe Referrals::PersonalDetails::QtsForm, type: :model do
  describe "#save" do
    let(:referral) { Referral.new }
    let(:has_qts) { "yes" }
    subject(:save) { qts_form.save }

    let(:qts_form) { described_class.new(referral:, has_qts:) }

    context "with a valid value" do
      it "saves the value on the referral" do
        save
        expect(referral.has_qts).to eq("yes")
      end
    end

    context "with no values" do
      let(:has_qts) { nil }
      it "adds an error" do
        save
        expect(qts_form.errors[:has_qts]).to eq(
          ["Tell us if you know whether they have QTS"]
        )
      end
    end

    context "with an invalid value" do
      let(:has_qts) { "eh?" }
      it "adds an error" do
        save
        expect(qts_form.errors[:has_qts]).to eq(
          ["Tell us if you know whether they have QTS"]
        )
      end
    end
  end
end
