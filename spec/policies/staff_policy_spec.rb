# frozen_string_literal: true

require "rails_helper"

RSpec.describe StaffPolicy do
  subject(:policy) { described_class.new(current_staff, staff_user) }

  let(:current_staff) { create(:staff, :confirmed, :can_view_support) }
  let(:staff_user) { nil }

  describe "#delete?" do
    subject(:delete?) { policy.delete? }

    it_behaves_like "staff policy deletion"
  end

  describe "#destroy?" do
    subject(:destroy?) { policy.destroy? }

    it_behaves_like "staff policy deletion"
  end
end
