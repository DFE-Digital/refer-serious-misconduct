class DeclarationForm
  include ActiveModel::Model

  attr_accessor :declaration_agreed, :referral

  validates :declaration_agreed, acceptance: true
  validates :referral, presence: true

  def save
    return false unless valid?

    referral.update(submitted_at: Time.current)
  end
end
