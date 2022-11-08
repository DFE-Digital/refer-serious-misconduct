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
#  user_id                   :bigint           not null
#
# Indexes
#
#  index_referrals_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :referral do
    user
  end
end
