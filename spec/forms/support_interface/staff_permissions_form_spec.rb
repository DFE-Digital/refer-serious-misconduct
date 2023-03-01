# frozen_string_literal: true
require "rails_helper"

RSpec.describe SupportInterface::StaffPermissionsForm, type: :model do
  let(:form) { described_class.new(params) }
  let(:staff) { build(:staff, view_support:, manage_referrals:) }
  let(:params) { { staff:, view_support:, manage_referrals: } }
  let(:view_support) { nil }
  let(:manage_referrals) { nil }

  describe "#valid?" do
    subject(:valid) { form.valid? }

    context "without permissions" do
      it "adds an error" do
        valid
        expect(form.errors[:permissions]).to eq(["Select permissions"])
      end
    end

    context "with view_support" do
      let(:view_support) { true }

      it { is_expected.to be true }
    end

    context "with manage_referrals" do
      let(:manage_referrals) { true }

      it { is_expected.to be true }
    end
  end

  describe "#save" do
    subject(:save) { form.save }

    context "without permissions" do
      it { is_expected.to be_falsey }
    end

    context "with permissions" do
      let(:view_support) { true }
      let(:manage_referrals) { true }

      it { is_expected.to be true }

      it "updates the staff" do
        save

        expect(staff.view_support).to be true
        expect(staff.manage_referrals).to be true
      end
    end
  end
end
