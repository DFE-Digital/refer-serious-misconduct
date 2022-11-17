class ReferralEvidence < ApplicationRecord
  has_one_attached :document, dependent: :destroy
end
