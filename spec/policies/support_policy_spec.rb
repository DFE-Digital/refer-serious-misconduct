# frozen_string_literal: true

require "rails_helper"

RSpec.describe SupportPolicy do
  subject(:policy) { described_class.new(user, record) }

  let(:user) { nil }
  let(:record) { :support }

  describe "#index?" do
    subject(:index?) { policy.index? }

    it_behaves_like "staff policy with permission", :can_view_support
  end

  describe "#create?" do
    subject(:create?) { policy.create? }

    it_behaves_like "staff policy with permission", :can_view_support
  end

  describe "#delete?" do
    subject(:delete?) { policy.delete? }

    it_behaves_like "staff policy with permission", :can_view_support
  end

  describe "#destroy?" do
    subject(:destroy?) { policy.destroy? }

    it_behaves_like "staff policy with permission", :can_view_support
  end

  describe "#activate?" do
    subject(:activate?) { policy.authenticate? }

    it_behaves_like "staff policy with permission", :can_view_support
  end

  describe "#deactivate?" do
    subject(:deactivate?) { policy.authenticate? }

    it_behaves_like "staff policy with permission", :can_view_support
  end
end
