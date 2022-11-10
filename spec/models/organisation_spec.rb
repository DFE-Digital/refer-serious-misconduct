# == Schema Information
#
# Table name: organisations
#
#  id           :bigint           not null, primary key
#  city         :string
#  completed_at :datetime
#  name         :string
#  postcode     :string
#  street_1     :string
#  street_2     :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  referral_id  :bigint           not null
#
# Indexes
#
#  index_organisations_on_referral_id  (referral_id)
#
# Foreign Keys
#
#  fk_rails_...  (referral_id => referrals.id)
#
require "rails_helper"

RSpec.describe Organisation, type: :model do
  it { is_expected.to belong_to(:referral) }

  describe "#address?" do
    subject { organisation.address? }

    context "when the address fields are all present" do
      let(:organisation) do
        build(
          :organisation,
          street_1: "Street",
          city: "London",
          postcode: "AB1 2CD"
        )
      end

      it { is_expected.to be_truthy }
    end

    context "when any of the address fields are not present" do
      let(:organisation) { build(:organisation, street_1: nil) }

      it { is_expected.to be_falsey }
    end
  end

  describe "#completed?" do
    context "when completed_at is not nil" do
      subject { build(:organisation, completed_at: Time.current) }

      it { is_expected.to be_completed }
    end

    context "when completed_at is nil" do
      subject { build(:organisation, completed_at: nil) }

      it { is_expected.not_to be_completed }
    end
  end

  describe "#status" do
    subject { organisation.status }

    context "when completed_at is not nil" do
      let(:organisation) { build(:organisation, completed_at: Time.current) }

      it { is_expected.to eq(:complete) }
    end

    context "when completed_at is nil" do
      let(:organisation) { build(:organisation, completed_at: nil) }

      it { is_expected.to eq(:incomplete) }
    end
  end
end
