# frozen_string_literal: true
require "rails_helper"

RSpec.describe Referrals::TeacherPersonalDetails::QtsForm, type: :model do
  describe "#save" do
    subject(:save) { qts_form.save }

    let(:referral) { build(:referral) }
    let(:qts_form) { described_class.new(referral:, has_qts:) }
    let(:has_qts) { "yes" }

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
        expect(qts_form.errors[:has_qts]).to eq(["Select yes if they have QTS"])
      end
    end

    context "with an invalid value" do
      let(:has_qts) { "eh?" }

      it "adds an error" do
        save
        expect(qts_form.errors[:has_qts]).to eq(["Select yes if they have QTS"])
      end
    end
  end
end
