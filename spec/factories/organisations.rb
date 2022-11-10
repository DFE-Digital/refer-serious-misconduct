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
FactoryBot.define do
  factory :organisation do
    referral
  end
end
