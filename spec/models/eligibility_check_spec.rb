# == Schema Information
#
# Table name: eligibility_checks
#
#  id           :bigint           not null, primary key
#  reporting_as :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
require "rails_helper"

RSpec.describe EligibilityCheck, type: :model do
  it { is_expected.to validate_presence_of(:reporting_as) }

  describe "#reporting_as_employer?" do
    subject { described_class.new(reporting_as:).reporting_as_employer? }

    let(:reporting_as) { nil }

    it { is_expected.to be_falsey }

    context "when reporting_as is public" do
      let(:reporting_as) { "public" }

      it { is_expected.to be_falsey }
    end

    context "when reporting_as is employer" do
      let(:reporting_as) { "employer" }

      it { is_expected.to be_truthy }
    end
  end
end
