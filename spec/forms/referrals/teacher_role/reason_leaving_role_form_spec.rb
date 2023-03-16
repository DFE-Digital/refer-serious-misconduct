# frozen_string_literal: true
require "rails_helper"

RSpec.describe Referrals::TeacherRole::ReasonLeavingRoleForm, type: :model do
  let(:form) { described_class.new(referral:, reason_leaving_role:) }
  let(:referral) { build(:referral) }
  let(:reason_leaving_role) { "" }
  let(:params) { {} }

  describe "validations" do
    it { is_expected.to validate_presence_of(:referral) }

    specify do
      expect(form).to validate_inclusion_of(:reason_leaving_role).in_array(%w[resigned dismissed retired unknown])
    end
  end

  describe "#valid?" do
    subject(:valid) { form.valid? }

    context "when reason_leaving_role is blank" do
      it "adds an error" do
        valid
        expect(form.errors[:reason_leaving_role]).to eq(["Select the reason they left the job"])
      end
    end
  end

  describe "#save" do
    subject(:save) { form.save }

    context "without a reason_leaving_role" do
      it { is_expected.to be_falsy }

      it "adds an error" do
        save
        expect(form.errors[:reason_leaving_role]).to eq(["Select the reason they left the job"])
      end
    end

    context "when reason_leaving_role is resigned" do
      let(:reason_leaving_role) { "resigned" }

      it "updates the employment_status to employed" do
        expect { form.save }.to change(referral, :reason_leaving_role).from(nil).to("resigned")
      end
    end
  end
end
