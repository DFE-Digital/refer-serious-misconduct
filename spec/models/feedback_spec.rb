require "rails_helper"

RSpec.describe Feedback, type: :model do
  subject(:form) { described_class.new }

  describe "validations" do
    it { is_expected.to validate_presence_of(:improvement_suggestion) }
    it { is_expected.not_to validate_presence_of(:email) }

    specify do
      expect(form).to validate_inclusion_of(:satisfaction_rating).in_array(
        %w[
          very_satisfied
          satisfied
          neither_satisfied_or_dissatisfied
          dissatisfied
          very_dissatisfied
        ]
      )
    end

    context "when contact permission is given" do
      subject(:form) { described_class.new(contact_permission_given: true) }

      it { is_expected.to validate_presence_of(:email) }
    end
  end
end
