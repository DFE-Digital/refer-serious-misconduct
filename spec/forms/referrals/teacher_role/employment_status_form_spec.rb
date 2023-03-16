# frozen_string_literal: true
require "rails_helper"

RSpec.describe Referrals::TeacherRole::EmploymentStatusForm, type: :model do
  let(:form) { described_class.new(referral:, employment_status:) }
  let(:employment_status) { "" }
  let(:referral) { build(:referral) }
  let(:date_params) { nil }

  describe "validations" do
    it { is_expected.to validate_presence_of(:referral) }

    specify { expect(form).to validate_inclusion_of(:employment_status).in_array(%w[employed suspended left_role]) }
  end

  describe "#valid?" do
    subject(:valid) { form.valid? }

    context "when employment_status is blank" do
      let(:employment_status) { "" }

      it "adds an error" do
        valid
        expect(form.errors[:employment_status]).to eq(
          ["Select whether they’re still employed where the alleged misconduct took place"]
        )
      end
    end
  end

  describe "#save" do
    subject(:save) { form.save }

    context "when employment_status is employed" do
      let(:employment_status) { "employed" }

      it "updates the employment_status to employed" do
        expect { form.save }.to change(referral, :employment_status).from(nil).to("employed")
      end
    end

    context "when employment_status is suspended" do
      let(:employment_status) { "suspended" }

      it "updates the employment_status to suspended" do
        expect { form.save }.to change(referral, :employment_status).from(nil).to("suspended")
      end
    end

    context "when employment_status is left_role" do
      let(:employment_status) { "left_role" }

      it "updates the employment_status to left_role" do
        expect { form.save }.to change(referral, :employment_status).from(nil).to("left_role")
      end
    end
  end
end
