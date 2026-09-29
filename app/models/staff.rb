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

  before_invitation_created :reactivate

  NO_PERMISSIONS = {
    view_support: false,
    manage_referrals: false,
    developer: false,
    feedback_notification: false
  }.freeze

  scope :active, -> { where(deleted_at: nil) }
  scope :archived, -> { where.not(deleted_at: nil) }

  # The invite form only sends the permissions that are ticked, so a returning
  # staff member's old permissions are cleared before the new ones are applied.
  def self.invite!(attributes = {}, invited_by = nil, options = {}, &block)
    attributes = attributes.to_h.with_indifferent_access
    attributes = NO_PERMISSIONS.merge(attributes) if archived_email?(attributes[:email])

    super(attributes, invited_by, options, &block)
  end

  def self.archived_email?(email)
    archived.exists?(devise_parameter_filter.filter(email:))
  end
  private_class_method :archived_email?

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

  # Removing staff archives their row rather than deleting it, so an
  # acceptance from before their removal must not block a new invitation.
  def invitation_taken?
    super && active?
  end

  private

  def active?
    deleted_at.nil?
  end

  # Clearing the earlier acceptance shows the new invitation as pending, with a
  # resend link, until they accept it.
  def reactivate
    self.deleted_at = nil
    self.invitation_accepted_at = nil
  end
end
