module ReferralFormSection
  extend ActiveSupport::Concern
  include ActiveModel::Model
  include ValidationTracking
  include CustomAttrs

  included do
    attr_accessor :referral

    validates :referral, presence: true

    def slug
      self.class.to_s.split("::")[1..].join.remove("Form").underscore.to_sym
    end

    def complete?
      valid_without_tracking?
    end

    def incomplete?
      !complete?
    end

    def path
      [:edit, referral.routing_scope, referral, slug.to_sym]
    end

    def section
      section_class.new(referral:)
    end

    def next_path
      check_answers? ? [:edit, referral.routing_scope, referral] : section.next_path
    end

    def check_answers?
      self.class.to_s.include? "CheckAnswers"
    end

    def section_class
      class_name = "Referrals::Sections::#{self.class.to_s.split("::").second}Section"
      class_name.constantize
    rescue NameError
      raise NotImplementedError, "Section class #{class_name} not found for #{self.class}"
    end

    def valid_upload_classes
      [ActionDispatch::Http::UploadedFile, Rack::Test::UploadedFile]
    end
  end
end
