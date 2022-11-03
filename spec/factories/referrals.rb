# == Schema Information
#
# Table name: referrals
#
#  id               :bigint           not null, primary key
#  boolean          :string
#  email_address    :string(256)
#  email_known      :string
#  first_name       :string
#  last_name        :string
#  name_has_changed :string
#  previous_name    :string
#  string           :string(256)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
FactoryBot.define do
  factory :referral do
  end
end
