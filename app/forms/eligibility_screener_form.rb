class EligibilityScreenerForm
  include ActiveModel::Model
  include CustomAttrs

  attr_accessor :eligibility_check
  validates :eligibility_check, presence: true
end
