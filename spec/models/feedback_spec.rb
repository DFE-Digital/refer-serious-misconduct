require "rails_helper"

RSpec.describe Feedback, type: :model do
  it do
    is_expected.to validate_inclusion_of(:satisfaction_rating).in_array(
      %w[very_satisfied satisfied neither_satisfied_or_dissatisfied dissatisfied very_dissatisfied]
    )
  end
end
