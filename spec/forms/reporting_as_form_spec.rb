require "rails_helper"

RSpec.describe ReportingAsForm, type: :model do
  it { is_expected.to validate_presence_of(:eligibility_check) }
  it { is_expected.to validate_presence_of(:reporting_as) }

  describe "#save" do
    subject(:save) { reporting_as_form.save }

    let(:eligibility_check) { EligibilityCheck.new }
    let(:reporting_as_form) do
      described_class.new(eligibility_check:, reporting_as:)
    end
    let(:reporting_as) { :employer }

    it "saves the reporting_as value on the eligibility check" do
      expect { save }.to change(eligibility_check, :reporting_as).from(nil).to(
        "employer"
      )
    end

    context "without a value for reporting_as" do
      let(:reporting_as) { nil }

      it { is_expected.to be_falsey }

      it "returns an informative error message" do
        save
        expect(reporting_as_form.errors["reporting_as"]).to eq(
          [
            "Tell us if you are reporting as an employer or a member of the public"
          ]
        )
      end
    end
  end
end
