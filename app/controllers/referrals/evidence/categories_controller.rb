module Referrals
  module Evidence
    class CategoriesController < Referrals::BaseController
      def edit
        @evidence_categories_form = CategoriesForm.new(
          referral: current_referral,
          evidence:
        )
      end

      def show
      end

      def update
        @evidence_categories_form =
          CategoriesForm.new(categories_params.merge(referral: current_referral, evidence:))

        if @evidence_categories_form.save
          if next_evidence
            redirect_to referrals_update_evidence_categories_path(current_referral, next_evidence)
          else
            redirect_to referrals_edit_evidence_confirm_path(current_referral)
          end
        else
          render :edit
        end
      end

      private

      def categories_params
        params.require(:referrals_evidence_categories_form).permit(
          :categories_other, categories: []
        )
      end

      def evidence
        @evidence ||= evidences.find(params[:evidence_id])
      end
      helper_method :evidence

      def evidences
        @evidences ||= current_referral.evidences
      end

      def next_evidence
        index = evidences.index(evidence)
        return if index.nil?

        evidences[index + 1]
      end
    end
  end
end
