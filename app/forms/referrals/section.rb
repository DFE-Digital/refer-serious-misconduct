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

    def label
      I18n.t("referral_form.#{slug}")
    end

    def start_path
      items.first.path
    end

    def check_answers_path
      [:edit, referral.routing_scope, referral, slug.to_sym, :check_answers]
    end

    def path
      complete_question_answered? ? check_answers_path : start_path
    end

    def next_path
      items.find(&:incomplete?).path
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

    # TODO: Remove this method once we've migrated to the new section structure
    def complete_question_answered?
      !complete?.nil?
    end
  end
end
