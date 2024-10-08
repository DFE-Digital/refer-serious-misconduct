# frozen_string_literal: true
require "rails_helper"

RSpec.describe Referrals::TeacherPersonalDetails::AgeForm, type: :model do
  let(:age_known) { "false" }
  let(:date_params) { {} }
  let(:form) { described_class.new(referral:, age_known:, date_params:) }
  let(:referral) { build(:referral) }

  context "with invalid age_known" do
    subject { form }

    let(:age_known) { "" }

    it { is_expected.to be_invalid }

    it "adds an error message" do
      form.valid?
      expect(form.errors[:age_known]).to eq(["Select yes if you know their date of birth"])
    end
  end

  describe "#save (date)" do
    let(:age_known) { "true" }

    it_behaves_like "form with a date validator", "date_of_birth"
    it_behaves_like "form with a date of birth validator", "date_of_birth"
  end

  describe "#save (age unknown)" do
    subject(:save) { form.save }

    let(:age_known) { "false" }

    before { save }

    it "does not update the date_of_birth" do
      expect(referral.date_of_birth).to be_nil
    end

    it "saves the age_known value" do
      expect(referral.age_known).to be(false)
    end

    context "when the date of birth was previously set" do
      let(:referral) { build(:referral, date_of_birth: 30.years.ago) }

      it "clears the date_of_birth" do
        expect(referral.date_of_birth).to be_nil
      end
    end
  end
end
