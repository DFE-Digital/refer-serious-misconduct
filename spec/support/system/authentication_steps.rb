module AuthenticationSteps
  def and_i_am_signed_in
    @user = create(:user)
    sign_in(@user)
  end
end
