# frozen_string_literal: true
require "rails_helper"

RSpec.describe Referrals::TeacherRole::StartDateForm, type: :model do
  subject(:form) do
    described_class.new(date_params:, referral:, role_start_date_known:)
  end

  let(:date_params) { nil }
  let(:referral) { build(:referral) }
  let(:role_start_date_known) { false }

  describe "#valid?" do
    subject(:valid) { form.valid? }

    before { valid }

    it { is_expected.to be_truthy }

    context "when role_start_date_known is blank" do
      let(:role_start_date_known) { "" }

      it { is_expected.to be_falsy }

      it "adds an error" do
        expect(form.errors[:role_start_date_known]).to eq(
          ["Select yes if you know when they started the job"]
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
        expect { form.save }.to change(referral, :role_start_date_known).from(
          nil
        ).to(false)
      end
    end
  end
end
