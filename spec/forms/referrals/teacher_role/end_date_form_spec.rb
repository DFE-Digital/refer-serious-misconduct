# frozen_string_literal: true
require "rails_helper"

RSpec.describe Referrals::TeacherRole::EndDateForm, type: :model do
  let(:form) { described_class.new(params) }
  let(:referral) { build(:referral) }
  let(:params) { {} }
  let(:date_params) { nil }

  describe "validations" do
    it { is_expected.to validate_presence_of(:referral) }

    specify do
      expect(form).to validate_inclusion_of(:role_end_date_known).in_array(
        [true, false]
      )
    end
  end

  describe "#valid?" do
    subject(:valid) { form.valid? }

    context "when role_end_date_known is blank" do
      let(:params) { { role_end_date_known: "" } }

      it "adds an error" do
        valid
        expect(form.errors[:role_end_date_known]).to eq(
          ["Select yes if you know when they left the job"]
        )
      end
    end
  end

  describe "#save" do
    subject(:save) { form.save }

    context "when role_end_date_known is true" do
      let(:params) { { date_params:, role_end_date_known: true, referral: } }
      let(:optional) { true }

      it_behaves_like "form with a date validator", "role_end_date"
    end
  end
end
