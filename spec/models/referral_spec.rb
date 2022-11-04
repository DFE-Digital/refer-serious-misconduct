# == Schema Information
#
# Table name: referrals
#
#  id               :bigint           not null, primary key
#  age_known        :string
#  approximate_age  :string
#  date_of_birth    :date
#  email_address    :string(256)
#  email_known      :boolean
#  first_name       :string
#  last_name        :string
#  name_has_changed :string
#  previous_name    :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
require "rails_helper"

RSpec.describe Referral, type: :model do
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
end
