class OrganisationNameForm
  include ActiveModel::Model

  attr_accessor :referral
  attr_writer :name

  validates :name, presence: true
  validates :referral, presence: true

  def name
    @name ||= organisation&.name
  end

  def organisation
    @organisation ||= referral&.organisation || referral&.build_organisation
  end

  def save
    return false unless valid?

    organisation.update(name:)
  end
end
