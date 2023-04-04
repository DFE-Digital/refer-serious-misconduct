class Staff < ApplicationRecord
  devise(
    :confirmable,
    :database_authenticatable,
    :invitable,
    :lockable,
    :recoverable,
    :rememberable,
    :timeoutable,
    :trackable,
    :validatable,
    validate_on_invite: true
  )

  validates :email, uniqueness: true, valid_for_notify: true
  validate :password_complexity
  validate :permissions_are_valid

  scope :active, -> { where(deleted_at: nil) }

  def password_complexity
    if password.blank? || password =~ /(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-])/
      return
    end

    errors.add(:password, :password_complexity)
  end

  def archive
    self.deleted_at = Time.zone.now
  end

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  def permissions_are_valid
    return if manage_referrals? || view_support?

    errors.add(:permissions, I18n.t("validation_errors.missing_staff_permission"))
  end

  def active_for_authentication?
    super && active?
  end

  private

  def active?
    deleted_at.nil?
  end
end
