# == Schema Information
#
# Table name: referrals
#
#  id               :bigint           not null, primary key
#  first_name       :string
#  last_name        :string
#  name_has_changed :integer
#  previous_name    :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Referral < ApplicationRecord
  enum :name_has_changed, { yes: 0, no: 1, dont_know: 2 }
end
