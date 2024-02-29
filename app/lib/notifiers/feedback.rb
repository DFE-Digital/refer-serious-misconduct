class Notifiers::Feedback
  def call
    staff_to_receive_feedback_notification.each do |staff|
      StaffMailer.feedback_notification(staff:).deliver_later
    end
  end

  private

  def staff_to_receive_feedback_notification
    Staff.where(feedback_notification: true)
  end
end
