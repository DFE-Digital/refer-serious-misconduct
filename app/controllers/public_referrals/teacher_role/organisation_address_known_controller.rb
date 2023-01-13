module PublicReferrals
  module TeacherRole
    class OrganisationAddressKnownController < Referrals::TeacherRole::OrganisationAddressKnownController
      private

      def next_path
        if current_referral.organisation_address_known?
          edit_public_referral_teacher_role_organisation_address_path(
            current_referral
          )
        else
          edit_public_referral_teacher_role_check_answers_path(current_referral)
        end
      end

      def update_path
        public_referral_teacher_role_organisation_address_known_path(
          current_referral
        )
      end

      def back_link
        edit_public_referral_teacher_role_duties_path(current_referral)
      end
    end
  end
end
