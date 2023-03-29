module ReferralFormSection
  extend ActiveSupport::Concern
  include ActiveModel::Model
  include ValidationTracking

  included do
    attr_accessor :referral

    validates :referral, presence: true

    def complete?
      valid?
    end

    def incomplete?
      !complete?
    end

    def path
      [:edit, referral.routing_scope, referral, slug.to_sym]
    end

    def slug
      self.class.to_s.split("::")[1..].join.remove("Form").underscore.to_sym
    end

    def section
      section_class.new(referral:)
    end

    def section_class
      "Referrals::Sections::#{self.class.to_s.split("::").second}Section".constantize
    end
  end
end
