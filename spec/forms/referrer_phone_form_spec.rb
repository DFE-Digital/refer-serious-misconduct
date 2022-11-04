require "rails_helper"

RSpec.describe ReferrerPhoneForm, type: :model do
  let(:referral) { build(:referral, referrer:) }
  let(:referrer) { build(:referrer) }

  describe "validations" do
    subject { described_class.new(referral:) }

    it { is_expected.to validate_presence_of(:referral) }
    it { is_expected.to validate_presence_of(:phone) }
  end

  describe "#save" do
    subject(:save) { form.save }

    let(:form) { described_class.new(phone:, referral:) }
    let(:phone) { "123456789" }
    let(:referral) { build(:referral, referrer:) }
    let(:referrer) { build(:referrer) }

    it "updates the referrer" do
      save
      expect(referrer.phone).to eq(phone)
    end

    context "when the form is invalid" do
      let(:form) { described_class.new(phone:, referral:) }
      let(:phone) { nil }
      let(:referral) { build(:referral, referrer:) }
      let(:referrer) { build(:referrer) }

      it { is_expected.to be_falsey }
    end
  end
end
