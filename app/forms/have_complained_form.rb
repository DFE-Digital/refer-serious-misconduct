class HaveComplainedForm
  include ActiveModel::Model

  attr_accessor :eligibility_check
  attr_reader :complained

  validates :eligibility_check, presence: true
  validates :complained, inclusion: { in: [true, false] }

  def complained=(value)
    @complained = ActiveModel::Type::Boolean.new.cast(value)
  end

  def save
    return false unless valid?

    eligibility_check.complained = complained
    eligibility_check.save
  end
end
