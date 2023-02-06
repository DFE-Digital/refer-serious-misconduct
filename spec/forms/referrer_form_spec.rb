require "rails_helper"

RSpec.describe ReferrerForm, type: :model do
  describe "validations" do
    subject(:form) { described_class.new(referrer:) }

    let(:referrer) { build(:referrer) }

    specify do
      expect(form).to validate_inclusion_of(:complete).in_array([true, false])
    end

    it { is_expected.to validate_presence_of(:referrer) }
  end

  describe "#complete" do
    subject(:form_complete) { referrer_form.complete }

    let(:complete) { nil }
    let(:referrer) { build(:referrer) }
    let(:referrer_form) { described_class.new(complete:, referrer:) }

    context "when the value of complete is nil" do
      let(:referrer) { build(:referrer) }

      it "returns the value from referrer" do
        expect(form_complete).to eq(referrer.completed?)
      end
    end

    context "when the value of complete is set" do
      let(:complete) { true }

      it "returns the value of complete" do
        expect(complete).to eq(true)
      end
    end
  end
end
