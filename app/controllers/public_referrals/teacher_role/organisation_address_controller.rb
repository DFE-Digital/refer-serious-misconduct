module PublicReferrals
  module TeacherRole
    class OrganisationAddressController < Referrals::TeacherRole::OrganisationAddressController
      private

      def next_path
        edit_public_referral_teacher_role_check_answers_path(current_referral)
      end

      def update_path
        public_referral_teacher_role_organisation_address_path(current_referral)
      end

      def back_link
        edit_public_referral_teacher_role_organisation_address_known_path(
          current_referral
        )
      end
    end
  end
end
