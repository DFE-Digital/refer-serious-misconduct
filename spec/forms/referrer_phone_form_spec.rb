require "rails_helper"

RSpec.describe ReferrerPhoneForm, type: :model do
  let(:referral) { build(:referral, referrer:) }
  let(:referrer) { build(:referrer) }
  let(:phone) { "07700 123456" }

  describe "validations" do
    subject(:form) { described_class.new(referral:, phone:) }

    it { is_expected.to validate_presence_of(:referral) }
    it { is_expected.to validate_presence_of(:phone) }

    context "when the phone number is blank" do
      let(:phone) { "" }

      it "adds an error" do
        form.validate
        expect(form.errors[:phone]).to eq(["Enter your phone number"])
      end
    end

    context "when the phone number is in an incorrect format" do
      let(:phone) { "invalid" }

      it { is_expected.to be_invalid }

      it "adds an error" do
        form.validate
        expect(form.errors[:phone]).to eq(
          [
            "Enter a phone number, like 01632 960 001, 07700 900 982 or +44 808 157 0192"
          ]
        )
      end
    end
  end

  describe "#save" do
    subject(:save) { form.save }

    let(:form) { described_class.new(phone:, referral:) }
    let(:phone) { "07700123456" }
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
