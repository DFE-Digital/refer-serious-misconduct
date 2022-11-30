# frozen_string_literal: true
require "rails_helper"

RSpec.describe Referrals::TeacherRole::EmploymentStatusForm, type: :model do
  let(:date_params) { {} }
  let(:employment_status) { "employed" }
  let(:reason_leaving_role) { nil }
  let(:referral) { build(:referral) }
  let(:role_end_date) { nil }
  let(:form) do
    described_class.new(
      date_params:,
      referral:,
      employment_status:,
      reason_leaving_role:,
      role_end_date:
    )
  end

  describe "#valid?" do
    subject(:valid) { form.valid? }

    it { is_expected.to be_truthy }

    before { valid }

    context "when employment_status is blank" do
      let(:employment_status) { "" }

      it { is_expected.to be_falsy }

      it "adds an error" do
        expect(form.errors[:employment_status]).to eq(
          ["Tell us if you know if they are still employed in that job"]
        )
      end
    end
  end

  describe "#save" do
    context "when employment_status is left_role" do
      subject(:save) { form.save }

      let(:employment_status) { "left_role" }
      let(:reason_leaving_role) { "resigned" }
      let(:optional) { true }

      it_behaves_like "form with a date validator", "role_end_date"

      context "without a reason_leaving_role" do
        let(:reason_leaving_role) { nil }

        before { save }

        it { is_expected.to be_falsy }

        it "adds an error" do
          expect(form.errors[:reason_leaving_role]).to eq(
            ["Tell us how they left this job"]
          )
        end
      end
    end

    context "when employment_status is suspended" do
      let(:employment_status) { "suspended" }

      it "updates the employment_status to suspended" do
        expect { form.save }.to change(referral, :employment_status).from(
          nil
        ).to("suspended")
      end
    end
  end
end
