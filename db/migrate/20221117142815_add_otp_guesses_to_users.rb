class AddOtpGuessesToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :otp_guesses, :integer
  end
end
