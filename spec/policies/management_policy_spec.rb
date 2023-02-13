# frozen_string_literal: true

require "rails_helper"

RSpec.describe ManagementPolicy do
  subject(:policy) { described_class.new(user, record) }

  let(:user) { nil }
  let(:record) { :management }

  describe "#index?" do
    subject(:index?) { policy.index? }

    context "without permission" do
      let(:user) { create(:staff, :confirmed) }

      it { is_expected.to be false }
    end

    context "with permission" do
      let(:user) { create(:staff, :confirmed, :can_manage_referrals) }

      it { is_expected.to be true }
    end

    context "with AnonymousSupportUser" do
      let(:user) { AnonymousSupportUser.new }

      it { is_expected.to be false }
    end
  end

  describe "#show?" do
    subject(:show?) { policy.show? }

    context "without permission" do
      let(:user) { create(:staff, :confirmed) }

      it { is_expected.to be false }
    end

    context "with permission" do
      let(:user) { create(:staff, :confirmed, :can_manage_referrals) }

      it { is_expected.to be true }
    end

    context "with AnonymousSupportUser" do
      let(:user) { AnonymousSupportUser.new }

      it { is_expected.to be false }
    end
  end
end
