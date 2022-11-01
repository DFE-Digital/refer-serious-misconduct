module Referrals
  module PersonalDetails
    class AgeController < ReferralsController
      def edit
        @personal_details_age_form = AgeForm.new(referral:)
      end

      def update
        @personal_details_age_form =
          AgeForm.new(approximate_age_params.merge(referral:))

        if @personal_details_age_form.save(date_of_birth_params)
          # TODO: Redirect to personal details TRN
        else
          render :edit
        end
      end

      private

      def approximate_age_params
        params.require(:referrals_personal_details_age_form).permit(
          :age_known,
          :approximate_age
        )
      end

      def date_of_birth_params
        params.require(:referrals_personal_details_age_form).permit(
          "date_of_birth(3i)",
          "date_of_birth(2i)",
          "date_of_birth(1i)"
        )
      end
    end
  end
end
