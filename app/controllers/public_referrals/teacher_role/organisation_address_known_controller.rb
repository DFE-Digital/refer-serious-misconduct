module PublicReferrals
  module TeacherRole
    class OrganisationAddressKnownController < Referrals::TeacherRole::OrganisationAddressKnownController
      private

      def previous_path
        polymorphic_path(
          [:edit, current_referral.routing_scope, current_referral, :teacher_role, :duties]
        )
      end
    end
  end
end
