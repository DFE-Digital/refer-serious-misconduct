require "rails_helper"

RSpec.describe ReferralForm do
  describe "#save" do
    subject(:save) { form.save }

    let(:form) { described_class.new(referral:) }
    let(:referral) { create(:referral) }

    it { is_expected.to be_falsy }

    context "when statuses are all complete" do
      let(:referral) { create(:referral, :complete) }

      it { is_expected.to be_truthy }
    end
  end

  describe "#sections" do
    subject(:sections) { form.sections }

    let(:form) { described_class.new(referral:) }

    context "when referral is from employer" do
      let(:referral) { create(:referral) }

      it "returns employer form section items" do
        labels = sections.flat_map(&:items).pluck(:label)
        expect(labels).to eq(
          [
            "Your details",
            "Your organisation",
            "Personal details",
            "Contact details",
            "About their role",
            "Details of the allegation",
            "Previous allegations",
            "Evidence and supporting information"
          ]
        )
      end
    end

    context "when referral is from member of public" do
      let(:referral) { create(:referral, eligibility_check: create(:eligibility_check, :public)) }

      it "returns public form section items" do
        labels = sections.flat_map(&:items).pluck(:label)
        expect(labels).to eq(
          [
            "Your details",
            "Personal details",
            "About their role",
            "Details of the allegation",
            "Evidence and supporting information"
          ]
        )
      end
    end
  end
end
