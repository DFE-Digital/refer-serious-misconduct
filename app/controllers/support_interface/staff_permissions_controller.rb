module SupportInterface
  class StaffPermissionsController < SupportInterfaceController
    def edit
      @staff_permissions_form =
        StaffPermissionsForm.new(
          view_support: staff.view_support,
          manage_referrals: staff.manage_referrals
        )
    end

    def update
      @staff_permissions_form =
        StaffPermissionsForm.new(staff_params.merge(staff:))

      if @staff_permissions_form.save
        flash[:success] = "Staff permissions updated for #{staff.email}"
        redirect_to support_interface_staff_index_path
      else
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

    def staff
      @staff ||= Staff.find(params[:id])
    end
  end
end
