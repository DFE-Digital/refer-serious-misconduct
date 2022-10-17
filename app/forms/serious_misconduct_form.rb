class SeriousMisconductForm
  include ActiveModel::Model

  attr_accessor :eligibility_check, :serious_misconduct

  validates :eligibility_check, presence: true
  validates :serious_misconduct, inclusion: { in: %w[yes no not_sure] }

  def save
    return false unless valid?

    eligibility_check.serious_misconduct = serious_misconduct
    eligibility_check.save
  end

  def eligible?
    eligibility_check.serious_misconduct?
  end

  def success_url
    unless eligible?
      return Rails.application.routes.url_helpers.not_serious_misconduct_path
    end

    Rails.application.routes.url_helpers.you_should_know_path
  end
end
