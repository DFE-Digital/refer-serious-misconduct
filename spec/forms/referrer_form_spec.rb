require "rails_helper"

RSpec.describe ReferrerForm, type: :model do
  describe "validations" do
    subject(:form) { described_class.new(referrer:) }

    let(:referrer) { build(:referrer) }

    specify do
      expect(form).to validate_inclusion_of(:complete).in_array([true, false])
    end

    it { is_expected.to validate_presence_of(:referrer) }
  end
end
