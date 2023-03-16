module PublicReferrals
  module TeacherRole
    class DutiesController < Referrals::TeacherRole::DutiesController
      def next_path
        [:edit, current_referral.routing_scope, current_referral, :teacher_role, :organisation_address_known]
      end
    end
  end
end
