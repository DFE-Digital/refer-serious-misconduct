module ReferralFormSection
  extend ActiveSupport::Concern
  include ActiveModel::Model
  include ValidationTracking

  included do
    attr_accessor :referral

    validates :referral, presence: true

    def slug
      raise NotImplementedError, "You must define slug in #{self.class}"
    end

    def complete?
      # We don't want to track validation errors when checking if a section is complete
      self.validation_tracking = false
      result = valid?
      self.validation_tracking = true
      result
    end

    def incomplete?
      !complete?
    end

    def path
      [:edit, referral.routing_scope, referral, slug.to_sym]
    end
  end
end
