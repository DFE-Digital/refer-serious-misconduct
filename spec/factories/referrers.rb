# == Schema Information
#
# Table name: referrers
#
#  id          :bigint           not null, primary key
#  name        :string
#  phone       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  referral_id :bigint           not null
#
# Indexes
#
#  index_referrers_on_referral_id  (referral_id)
#
# Foreign Keys
#
#  fk_rails_...  (referral_id => referrals.id)
#
FactoryBot.define do
  factory :referrer do
    referral { nil }
    name { "MyString" }

    trait :incomplete do
      name { nil }
    end
  end
end
