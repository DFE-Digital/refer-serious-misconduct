# == Schema Information
#
# Table name: organisations
#
#  id           :bigint           not null, primary key
#  completed_at :datetime
#  name         :string
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
class Organisation < ApplicationRecord
  belongs_to :referral

  def completed?
    completed_at.present?
  end

  def status
    return :complete if completed?

    :incomplete
  end
end
