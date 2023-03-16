module SupportInterface
  class StaffController < SupportInterfaceController
    before_action :can_delete, only: %i[destroy delete]

    def index
      @staff = Staff.active.order(:email)
    end

    def destroy
      staff_user.archive

      flash[:info] = (staff_user.save ? "User deleted" : "User could not be deleted")

      redirect_to support_interface_staff_index_path
    end

    private

    def can_delete
      if current_staff.id == staff_user.id
        flash[:info] = "You cannot delete your own user"

        redirect_to support_interface_staff_index_path and return
      end
    end

    def staff_user
      @staff_user ||= Staff.find(params[:id])
    end
  end
end
