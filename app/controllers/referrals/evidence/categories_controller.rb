module Referrals
  module Evidence
    class CategoriesController < Referrals::BaseController
      def edit
        @evidence_categories_form =
          CategoriesForm.new(referral: current_referral, evidence:)
      end

      def update
        @evidence_categories_form =
          CategoriesForm.new(
            categories_params.merge(referral: current_referral, evidence:)
          )

        if @evidence_categories_form.save
          set_back_link
          next_evidence = @evidence_categories_form.next_evidence
          if next_evidence.present?
            redirect_to referrals_update_evidence_categories_path(
                          current_referral,
                          next_evidence
                        )
          else
            redirect_to referrals_edit_evidence_check_answers_path(
                          current_referral
                        )
          end
        else
          render :edit
        end
      end

      private

      def categories_params
        params.require(:referrals_evidence_categories_form).permit(
          :categories_other,
          categories: []
        )
      end

      def evidence
        @evidence ||= current_referral.evidences.find(params[:evidence_id])
      end
      helper_method :evidence

      def set_back_link
        session[:evidence_back_link] = request.url
      end
    end
  end
end
