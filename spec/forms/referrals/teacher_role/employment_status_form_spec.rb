# frozen_string_literal: true
require "rails_helper"

RSpec.describe Referrals::TeacherRole::EmploymentStatusForm, type: :model do
  let(:form) { described_class.new(params) }
  let(:referral) { build(:referral) }
  let(:params) { {} }
  let(:date_params) { nil }

  describe "validations" do
    it { is_expected.to validate_presence_of(:referral) }

    specify do
      expect(form).to validate_inclusion_of(:employment_status).in_array(
        %w[employed suspended left_role]
      )
    end
  end

  describe "#valid?" do
    subject(:valid) { form.valid? }

    context "when employment_status is blank" do
      let(:params) { { employment_status: "" } }

      it "adds an error" do
        valid
        expect(form.errors[:employment_status]).to eq(
          [
            "Select whether they’re still employed where the alleged misconduct took place"
          ]
        )
      end
    end
  end

  describe "#save" do
    subject(:save) { form.save }

    context "when employment_status is left_role" do
      let(:params) do
        {
          date_params:,
          employment_status: "left_role",
          reason_leaving_role: "resigned",
          referral:
        }
      end
      let(:optional) { true }

      it_behaves_like "form with a date validator", "role_end_date"
    end

    context "without a reason_leaving_role" do
      let(:params) { { employment_status: "left_role", referral: } }

      it { is_expected.to be_falsy }

      it "adds an error" do
        save
        expect(form.errors[:reason_leaving_role]).to eq(
          ["Select the reason they left the job"]
        )
      end
    end

    context "when employment_status is suspended" do
      let(:params) { { employment_status: "suspended", referral: } }

      it "updates the employment_status to suspended" do
        expect { form.save }.to change(referral, :employment_status).from(
          nil
        ).to("suspended")
      end
    end
  end
end
