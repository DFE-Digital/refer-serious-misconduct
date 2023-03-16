module Referrals
  module PersonalDetails
    class NameController < Referrals::BaseController
      def edit
        @personal_details_name_form =
          NameForm.new(
            first_name: current_referral.first_name,
            last_name: current_referral.last_name,
            name_has_changed: current_referral.name_has_changed,
            previous_name: current_referral.previous_name
          )
      end

      def update
        @personal_details_name_form = NameForm.new(name_params.merge(referral: current_referral))

        if @personal_details_name_form.save
          redirect_to next_page
        else
          render :edit
        end
      end

      private

      def next_path
        [:edit, current_referral.routing_scope, current_referral, :personal_details, :age]
      end

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
