module Referrals
  module Sections
    class OrganisationSection < Section
      def items
        [Organisation::AddressForm.new(referral:), Organisation::CheckAnswersForm.new(referral:)]
      end

      def slug
        "organisation"
      end

      def complete?
        referral.organisation&.complete
      end

      def label
        I18n.t("referral_form.your_organisation")
      end

      def view_component(**args)
        OrganisationComponent.new(referral:, **args)
      end
    end
  end
end
