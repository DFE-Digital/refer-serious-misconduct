class AddLastOtpCreatedAtToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :last_otp_created_at, :timestamp
  end
end
