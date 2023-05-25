require "rails_helper"

RSpec.describe Referrals::ReferrerDetails::CheckAnswersForm, type: :model do
  describe "validations" do
    subject(:form) { described_class.new(referrer:) }

    let(:referrer) { build(:referrer) }

    it { is_expected.to validate_presence_of(:referrer) }
  end
end
