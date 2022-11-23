# frozen_string_literal: true
require "rails_helper"

RSpec.describe Referrals::TeacherRole::SameOrganisationForm, type: :model do
  let(:referral) { build(:referral) }
  let(:same_organisation) { true }
  subject(:form) { described_class.new(referral:, same_organisation:) }

  describe "#valid?" do
    subject(:valid) { form.valid? }

    it { is_expected.to be_truthy }

    before { valid }

    context "when same_organisation is blank" do
      let(:same_organisation) { "" }

      it { is_expected.to be_falsy }

      it "adds an error" do
        expect(form.errors[:same_organisation]).to eq(
          ["Tell us if they work in the same organisation as you"]
        )
      end
    end
  end

  describe "#save" do
    context "when same_organisation is true" do
      let(:same_organisation) { true }

      it "updates the same_organisation to true" do
        expect { form.save }.to change(referral, :same_organisation).from(
          nil
        ).to(true)
      end
    end

    context "when same_organisation is false" do
      let(:same_organisation) { false }

      it "updates the same_organisation to false" do
        expect { form.save }.to change(referral, :same_organisation).from(
          nil
        ).to(false)
      end
    end
  end
end
