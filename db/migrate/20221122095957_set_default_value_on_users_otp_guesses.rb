class SetDefaultValueOnUsersOtpGuesses < ActiveRecord::Migration[7.0]
  def change
    change_column_default :users, :otp_guesses, from: nil, to: 0
    User.where(otp_guesses: nil).update_all(otp_guesses: 0)
  end
end
