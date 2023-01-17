module Referrals
  module TeacherRole
    class WorkingSomewhereElseController < Referrals::BaseController
      def edit
        @working_somewhere_else_form =
          WorkingSomewhereElseForm.new(
            working_somewhere_else: current_referral.working_somewhere_else
          )
      end

      def update
        @working_somewhere_else_form =
          WorkingSomewhereElseForm.new(
            working_somewhere_else_params.merge(referral: current_referral)
          )

        if @working_somewhere_else_form.save
          redirect_to next_page
        else
          render :edit
        end
      end

      private

      def working_somewhere_else_params
        params.require(
          :referrals_teacher_role_working_somewhere_else_form
        ).permit(:working_somewhere_else)
      end

      def next_path
        if current_referral.working_somewhere_else?
          [
            :edit,
            current_referral.routing_scope,
            current_referral,
            :teacher_role,
            :work_location_known
          ]
        else
          [
            :edit,
            current_referral.routing_scope,
            current_referral,
            :teacher_role,
            :check_answers
          ]
        end
      end

      def next_page
        if @working_somewhere_else_form.referral.saved_changes? &&
             current_referral.working_somewhere_else
          return next_path
        end

        super
      end
    end
  end
end
