# == Schema Information
#
# Table name: referrals
#
#  id                        :bigint           not null, primary key
#  address_known             :boolean
#  address_line_1            :string
#  address_line_2            :string
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
class Referral < ApplicationRecord
  has_one :referrer, dependent: :destroy

  def referrer_status
    return :not_started_yet if referrer.blank?

    referrer.status
  end
end
