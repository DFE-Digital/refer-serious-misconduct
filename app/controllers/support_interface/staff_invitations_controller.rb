module SupportInterface
  class StaffInvitationsController < SupportInterfaceController
    def edit
      @staff = Staff.find(params[:id])
    end

    def update
      @staff = Staff.find(params[:id])

      if @staff.invite!(current_staff)
        flash[:success] = "Invitation sent"
        redirect_to support_interface_staff_index_path
      else
        flash[:warning] = "Invitation failed to send"
        render :edit
      end
    end

    private

    def staff_params
      params.require(:support_interface_staff_permissions_form).permit(
        :manage_referrals,
        :view_support
      )
    end
  end
end
