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
      end

      def update
        @personal_details_name_form = NameForm.new(name_params.merge(referral:))

        if @personal_details_name_form.save
          redirect_to referrals_edit_personal_details_age_path(referral)
        else
          render :edit
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
