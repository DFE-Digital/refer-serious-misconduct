# frozen_string_literal: true
module SupportInterface
  class TestUsersController < SupportInterfaceController
    before_action :redirect_unless_test_environment

    def index
      @pagy, @users = pagy(User.newest_first)
    end

    def create
      user = FactoryBot.create(:user)
      flash[:success] = "User #{user.email} created"
      redirect_to support_interface_test_users_path
    end

    def authenticate
      user = User.find(params.fetch(:id))
      sign_in(user)
      redirect_to root_path
    end

    private

    def redirect_unless_test_environment
      unless HostingEnvironment.test_environment?
        flash[:warning] = "Test users can only be accessed on test environments"
        redirect_to support_interface_root_path
      end
    end
  end
end
