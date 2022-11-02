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
#  trn              :string
#  trn_known        :boolean
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Referral < ApplicationRecord
  has_one :referrer, dependent: :destroy

  def referrer_status
    return :not_started_yet if referrer.blank?

    referrer.status
  end
end
