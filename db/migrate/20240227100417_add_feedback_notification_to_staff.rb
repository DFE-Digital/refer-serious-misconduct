class AddFeedbackNotificationToStaff < ActiveRecord::Migration[7.0]
  def change
    add_column :staff, :feedback_notification, :boolean, default: false
  end
end
