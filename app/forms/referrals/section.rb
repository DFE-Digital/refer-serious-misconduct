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
      raise NotImplementedError, "You must define slug in #{self.class}"
    end

    def view_component(user:)
      raise NotImplementedError, "You must define view_component in #{self.class}"
    end

    def section
      self
    end

    def label
      I18n.t("referral_form.#{slug}")
    end

    def error_id
      "referral-form-section-#{slug}-field-error"
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
      items.find(&:incomplete?)&.path || start_path
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
      if rows.is_a?(Hash)
        rows.filter_map { |k, v| v if items[k].complete? }.flatten
      else
        rows.select.with_index { |_i, idx| items[idx].complete? }
      end
    end
  end
end
