class RegistrationExistsForm
  include ActiveModel::Model

  attr_accessor :registration_exists

  validates :registration_exists, inclusion: { in: %w[yes no] }

  def registration_exists?
    registration_exists == "yes"
  end

  def save
    valid?
  end
end
