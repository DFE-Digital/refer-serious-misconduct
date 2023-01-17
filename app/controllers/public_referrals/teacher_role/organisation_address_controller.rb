module PublicReferrals
  module TeacherRole
    class OrganisationAddressController < Referrals::TeacherRole::OrganisationAddressController
      def next_path
        [
          :edit,
          current_referral.routing_scope,
          current_referral,
          :teacher_role,
          :check_answers
        ]
      end
    end
  end
end
