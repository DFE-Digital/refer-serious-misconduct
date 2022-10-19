class UnsupervisedTeachingForm
  include ActiveModel::Model

  attr_accessor :eligibility_check, :unsupervised_teaching

  validates :eligibility_check, presence: true
  validates :unsupervised_teaching, inclusion: { in: %w[yes no not_sure] }

  def save
    return false unless valid?

    eligibility_check.unsupervised_teaching = unsupervised_teaching
    eligibility_check.save
  end
end
