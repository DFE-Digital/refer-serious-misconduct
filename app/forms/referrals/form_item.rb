module Referrals
  class FormItem
    include ActiveModel::Model
    include ActiveModel::Validations
    include ValidationTracking
    include CustomAttrs

    attr_accessor :referral

    validates :referral, presence: true

    delegate :label, to: :section, prefix: true

    def complete?
      valid_without_tracking?
    end

    def incomplete?
      !complete?
    end

    def path
      [:edit, referral.routing_scope, referral, section.slug, slug]
    end

    def edit_path
      [:edit, referral.routing_scope, referral]
    end

    def form_path
      [referral.routing_scope, referral, section.slug, slug]
    end

    def section
      section_class.new(referral:)
    end

    def next_path
      check_answers? ? edit_path : section.next_path
    end

    def previous_path
      check_answers? || first? ? edit_path : section.previous_path
    end

    def first?
      section.items.first == self
    end

    def check_answers?
      self.class.to_s.include? "CheckAnswers"
    end

    def label
      I18n.t("referral_form.forms.#{section.slug}.#{slug}")
    end

    def page_title
      if check_answers?
        "Check and confirm your answers - #{section_label}"
      else
        "#{"Error: " if errors.any?}#{label} - #{section_label}"
      end
    end

    # Turns a class name like module Referrals::ReferrerDetails::NameForm into a slug like :name
    def slug
      self.class.to_s.split("::").last.remove("Form").underscore.to_sym
    end

    # Turns a class name like module Referrals::ReferrerDetails::NameForm into a section class
    # like Referrals::Sections::ReferrerDetailsSection
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
