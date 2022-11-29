require "rails_helper"

RSpec.describe DeclarationForm, type: :model do
  it { is_expected.to validate_presence_of(:referral) }

  describe "#save" do
    subject(:save) { form.save }

    let(:form) { described_class.new(declaration_agreed:, referral:) }
    let(:referral) { build(:referral) }

    context "when the form is valid" do
      let(:declaration_agreed) { "1" }

      it "updates the referral's submitted_at timestamp" do
        form.save

        expect(referral.submitted_at).to be_present
      end
    end

    context "when the form is invalid" do
      let(:declaration_agreed) { "0" }

      it { is_expected.to be_falsey }
    end
  end
end
