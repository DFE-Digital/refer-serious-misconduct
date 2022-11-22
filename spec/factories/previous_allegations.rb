# == Schema Information
#
# Table name: previous_allegations
#
#  id           :bigint           not null, primary key
#  completed_at :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  referral_id  :bigint           not null
#
# Indexes
#
#  index_previous_allegations_on_referral_id  (referral_id)
#
# Foreign Keys
#
#  fk_rails_...  (referral_id => referrals.id)
#
FactoryBot.define do
  factory :previous_allegation do
    referral

    trait :incomplete do
      completed_at { nil }
    end
  end
end
