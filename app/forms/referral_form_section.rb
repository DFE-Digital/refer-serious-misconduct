module ReferralFormSection
  extend ActiveSupport::Concern
  include ActiveModel::Model
  include ValidationTracking

  included do
    attr_accessor :referral

    validates :referral, presence: true
  end
end
