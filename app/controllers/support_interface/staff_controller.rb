module SupportInterface
  class StaffController < SupportInterfaceController
    def index
      @staff = Staff.order(:email)
    end
  end
end
