require "rails_helper"

RSpec.describe OrganisationForm, type: :model do
  it { is_expected.to validate_presence_of(:referral) }

  describe "#save" do
    subject(:save) { form.save }

    let(:complete) { "true" }
    let(:form) { described_class.new(complete:, referral:) }
    let(:organisation) { build(:organisation) }
    let(:referral) { organisation.referral }

    it { is_expected.to be_truthy }

    it "updates the organisation" do
      save
      expect(organisation).to be_completed
    end

    context "when the form is not valid" do
      let(:referral) { nil }

      it { is_expected.to be_falsey }
    end
  end
end
