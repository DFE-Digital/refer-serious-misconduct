class ReferrerPhoneForm
  include ActiveModel::Model

  attr_accessor :referral
  attr_writer :phone

  validates :referral, presence: true
  validates :phone, presence: true

  def phone
    @phone ||= referrer&.phone
  end

  def save
    return false unless valid?

    referrer.update(phone:)
  end

  delegate :referrer, to: :referral, allow_nil: true
end
