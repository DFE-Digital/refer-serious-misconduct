# frozen_string_literal: true

require "rails_helper"

RSpec.describe SupportPolicy do
  subject(:policy) { described_class.new(user, record) }

  let(:user) { nil }
  let(:record) { :support }

  describe "#index?" do
    subject(:index?) { policy.index? }

    context "without permission" do
      let(:user) { create(:staff, :confirmed) }

      it { is_expected.to be false }
    end

    context "with permission" do
      let(:user) { create(:staff, :confirmed, :can_view_support) }

      it { is_expected.to be true }
    end

    context "with AnonymousSupportUser" do
      let(:user) { AnonymousSupportUser.new }

      it { is_expected.to be false }
    end
  end

  describe "#create?" do
    subject(:create?) { policy.create? }

    context "without permission" do
      let(:user) { create(:staff, :confirmed) }

      it { is_expected.to be false }
    end

    context "with permission" do
      let(:user) { create(:staff, :confirmed, :can_view_support) }

      it { is_expected.to be true }
    end

    context "with AnonymousSupportUser" do
      let(:user) { AnonymousSupportUser.new }

      it { is_expected.to be false }
    end
  end

  describe "#authenticate?" do
    subject(:authenticate?) { policy.authenticate? }

    context "without permission" do
      let(:user) { create(:staff, :confirmed) }

      it { is_expected.to be false }
    end

    context "with permission" do
      let(:user) { create(:staff, :confirmed, :can_view_support) }

      it { is_expected.to be true }
    end

    context "with AnonymousSupportUser" do
      let(:user) { AnonymousSupportUser.new }

      it { is_expected.to be false }
    end
  end
end
