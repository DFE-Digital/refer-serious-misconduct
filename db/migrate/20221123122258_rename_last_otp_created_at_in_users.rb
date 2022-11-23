class RenameLastOtpCreatedAtInUsers < ActiveRecord::Migration[7.0]
  def change
    rename_column :users, :last_otp_created_at, :otp_created_at
  end
end
