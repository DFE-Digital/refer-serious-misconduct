module Referrals
  class Section
    include ActiveModel::Model
    include ActiveModel::Attributes
    include Rails.application.routes.url_helpers

    attribute :referral

    def items
      raise NotImplementedError, "You must define items in #{self.class}"
    end

    def complete?
      raise NotImplementedError, "You must define complete? in #{self.class}"
    end

    def slug
      self.class.to_s.split("::").last.remove("Section").underscore.to_sym
    end

    def view_component(user:)
      raise NotImplementedError, "You must define view_component in #{self.class}"
    end

    def section
      self
    end

    def label
      I18n.t("referral_form.sections.#{slug}")
    end

    def error_id
      "referral-form-section-#{slug.to_s.dasherize}-field-error"
    end

    def start_path
      items.first.path
    end

    def check_answers_path
      [:edit, referral.routing_scope, referral, slug.to_sym, :check_answers]
    end

    def path
      started? ? check_answers_path : start_path
    end

    def next_path
      items.find(&:incomplete?)&.path || path
    end

    def previous_path
      items.reverse.find(&:complete?)&.path || [:edit, referral.routing_scope, referral]
    end

    def status
      complete? ? :completed : :incomplete
    end

    def incomplete?
      !complete?
    end

    def questions_complete?
      items[0..-2].all?(&:complete?)
    end

    def questions_incomplete?
      !questions_complete?
    end

    def started?
      items.first.complete?
    end

    def complete_rows(rows)
      if rows&.first.is_a?(Array)
        rows.filter_map.with_index { |row_group, idx| row_group if items[idx].complete? }.flatten
      else
        rows.select.with_index { |_i, idx| items[idx]&.complete? }
      end
    end
  end
end
