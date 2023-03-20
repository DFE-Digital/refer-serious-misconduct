module SupportInterface
  class StaffController < SupportInterfaceController
    def index
      @staff = Staff.active.order(:email)
    end

    def delete
      authorize staff
    end

    def destroy
      authorize staff

      staff.archive

      flash[:info] = (staff.save ? "User deleted" : "User could not be deleted")

      redirect_to support_interface_staff_index_path
    end

    private

    def staff
      @staff ||= Staff.find(params[:id])
    end
  end
end
