class OrganisationAddressForm
  include ActiveModel::Model

  attr_accessor :referral
  attr_writer :street_1, :street_2, :city, :postcode

  validates :city, presence: true
  validates :postcode, presence: true
  validates :referral, presence: true
  validates :street_1, presence: true

  def city
    @city ||= organisation&.city
  end

  delegate :organisation, to: :referral, allow_nil: true

  def postcode
    @postcode ||= organisation&.postcode
  end

  def street_1
    @street_1 ||= organisation&.street_1
  end

  def street_2
    @street_2 ||= organisation&.street_2
  end

  def save
    return false unless valid?

    organisation.update(city:, postcode:, street_1:, street_2:)
  end
end
