# == Schema Information
#
# Table name: referrals
#
#  id               :bigint           not null, primary key
#  age_known        :integer
#  approximate_age  :string
#  date_of_birth    :date
#  first_name       :string
#  last_name        :string
#  name_has_changed :string
#  previous_name    :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Referral < ApplicationRecord
end
