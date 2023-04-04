module PublicReferrals
  module TeacherRole
    class OrganisationAddressKnownController < Referrals::TeacherRole::OrganisationAddressKnownController
      private

      def next_path
        if current_referral.organisation_address_known?
          [
            :edit,
            current_referral.routing_scope,
            current_referral,
            :teacher_role,
            :organisation_address
          ]
        else
          [:edit, current_referral.routing_scope, current_referral, :teacher_role, :check_answers]
        end
      end

      def back_link
        polymorphic_path(
          [:edit, current_referral.routing_scope, current_referral, :teacher_role, :duties]
        )
      end
    end
  end
end
