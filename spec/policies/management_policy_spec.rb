# frozen_string_literal: true

require "rails_helper"

RSpec.describe ManagementPolicy do
  subject(:policy) { described_class.new(user, record) }

  let(:user) { nil }
  let(:record) { :management }

  describe "#index?" do
    subject(:index?) { policy.index? }

    it_behaves_like "staff policy with permission", :can_manage_referrals
  end

  describe "#show?" do
    subject(:show?) { policy.show? }

    it_behaves_like "staff policy with permission", :can_manage_referrals
  end
end
