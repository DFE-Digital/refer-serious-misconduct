# == Schema Information
#
# Table name: referrals
#
#  id                        :bigint           not null, primary key
#  address_known             :boolean
#  address_line_1            :string
#  address_line_2            :string
#  age_known                 :boolean
#  contact_details_complete  :boolean
#  country                   :string
#  date_of_birth             :date
#  email_address             :string(256)
#  email_known               :boolean
#  first_name                :string
#  has_qts                   :string
#  last_name                 :string
#  name_has_changed          :string
#  personal_details_complete :boolean
#  phone_known               :boolean
#  phone_number              :string
#  postcode                  :string(11)
#  previous_name             :string
#  town_or_city              :string
#  trn                       :string
#  trn_known                 :boolean
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
require "rails_helper"

RSpec.describe Referral, type: :model do
  it { is_expected.to have_one(:organisation).dependent(:destroy) }
  it { is_expected.to have_one(:referrer).dependent(:destroy) }

  describe "#referrer_status" do
    subject { referral.referrer_status }

    let(:referral) { build(:referral) }

    it { is_expected.to eq(:not_started_yet) }

    context "when a referrer is present" do
      let(:referral) do
        build(:referral, referrer: build(:referrer, :incomplete))
      end

      it { is_expected.to eq(:incomplete) }
    end
  end

  describe "#organisation_status" do
    subject { referral.organisation_status }

    let(:referral) { build(:referral) }

    it { is_expected.to eq(:not_started_yet) }

    context "when an organisation is present" do
      let(:referral) { build(:organisation).referral }

      it { is_expected.to eq(:incomplete) }
    end
  end
end
