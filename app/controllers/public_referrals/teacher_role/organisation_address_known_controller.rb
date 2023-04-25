module PublicReferrals
  module TeacherRole
    class OrganisationAddressKnownController < Referrals::TeacherRole::OrganisationAddressKnownController
      private

      def back_link
        polymorphic_path(
          [:edit, current_referral.routing_scope, current_referral, :teacher_role, :duties]
        )
      end
    end
  end
end
