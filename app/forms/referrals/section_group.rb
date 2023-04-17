module Referrals
  class SectionGroup
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :slug
    attribute :items, default: []

    def label
      I18n.t("referral_form.#{slug}")
    end

    def complete?
      items.all?(&:complete?)
    end
  end
end
