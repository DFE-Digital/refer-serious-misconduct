class OrganisationForm
  include ActiveModel::Model

  attr_accessor :referral
  attr_writer :complete

  validates :complete, inclusion: { in: %w[true false] }
  validates :referral, presence: true

  def complete
    @complete || organisation&.completed_at? || nil
  end

  def save
    return false unless valid?

    organisation.update(completed_at: complete == "true" ? Time.current : nil)
  end

  private

  def organisation
    @organisation ||= referral&.organisation || referral&.build_organisation
  end
end
