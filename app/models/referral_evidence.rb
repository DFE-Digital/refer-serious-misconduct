class ReferralEvidence < ApplicationRecord
  belongs_to :referral
  has_one_attached :document
end
