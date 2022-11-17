# frozen_string_literal: true
require "rails_helper"

RSpec.describe Referrals::TeacherRole::StartDateForm, type: :model do
  let(:referral) { build(:referral) }
  let(:role_start_date_known) { true }
  subject(:date_form) { described_class.new(referral:, role_start_date_known:) }

  describe "#valid?" do
    subject(:valid) { date_form.valid? }

    it { is_expected.to be_truthy }

    before { valid }

    context "when role_start_date_known is blank" do
      let(:role_start_date_known) { "" }

      it { is_expected.to be_falsy }

      it "adds an error" do
        expect(date_form.errors[:role_start_date_known]).to eq(
          ["Tell us if you know their role start date"]
        )
      end
    end
  end

  describe "#save" do
    context "when role_start_date_known is true" do
      let(:role_start_date_known) { true }

      it_behaves_like "form with a date validator", "role_start_date"
    end

    context "when role_start_date_known is false" do
      let(:role_start_date_known) { false }

      it "updates the start_date_known to false" do
        expect { date_form.save }.to change(
          referral,
          :role_start_date_known
        ).from(nil).to(false)
      end
    end
  end
end
