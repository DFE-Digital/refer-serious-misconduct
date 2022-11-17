# frozen_string_literal: true
require "rails_helper"

RSpec.describe Referrals::PersonalDetails::AgeForm, type: :model do
  let(:referral) { build(:referral) }
  let(:age_known) { "false" }

  let(:date_form) { described_class.new(referral:, age_known:) }

  context "with invalid age_known" do
    let(:age_known) { "" }

    it "adds an error message" do
      expect(date_form.valid?).to be false
      expect(date_form.errors[:age_known]).to eq(
        ["Tell us if you know their date of birth"]
      )
    end
  end

  describe "#save (date)" do
    let(:age_known) { "true" }

    it_behaves_like "form with a date validator", "date_of_birth"
    it_behaves_like "form with a date of birth validator", "date_of_birth"
  end

  describe "#save (age unknown)" do
    subject(:save) { date_form.save }

    let(:age_known) { "false" }
    let(:date_form) { described_class.new(referral:, age_known:) }

    it "saves the age_known value without a date of birth" do
      save
      expect(referral.date_of_birth).to be nil
      expect(referral.age_known).to eq(false)
    end
  end
end
