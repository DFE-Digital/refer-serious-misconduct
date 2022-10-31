module Referrals
  module PersonalDetails
    class NameController < ReferralsController
      def edit
        @personal_details_name_form =
          NameForm.new(
            referral:,
            first_name: referral.first_name,
            last_name: referral.last_name,
            name_has_changed: referral.previous_name.present?,
            previous_name: referral.previous_name
          )

        render "referrals/personal_details/name"
      end

      def update
        @personal_details_name_form = NameForm.new(name_params.merge(referral:))

        if @personal_details_name_form.save
          # TODO: Redirect to personal details DOB
        else
          render "referrals/personal_details/name"
        end
      end

      private

      def name_params
        params.require(:referrals_personal_details_name_form).permit(
          :first_name,
          :last_name,
          :name_has_changed,
          :previous_name
        )
      end
    end
  end
end
