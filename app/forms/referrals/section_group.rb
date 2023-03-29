module Referrals
  class SectionGroup
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :referral

    def items
      raise NotImplementedError, "You must define items in #{self.class}"
    end

    def label
      I18n.t("referral_form.#{slug}")
    end

    def slug
      self.class.to_s.demodulize.remove("SectionGroup").underscore
    end

    def complete?
      items.all?(&:complete?)
    end
  end
end
