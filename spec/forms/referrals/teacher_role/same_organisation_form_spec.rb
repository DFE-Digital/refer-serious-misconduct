# frozen_string_literal: true
require "rails_helper"

RSpec.describe Referrals::TeacherRole::SameOrganisationForm, type: :model do
  subject(:form) { described_class.new(referral:, same_organisation:) }

  let(:referral) { build(:referral) }
  let(:same_organisation) { true }

  describe "#valid?" do
    subject(:valid) { form.valid? }

    before { valid }

    it { is_expected.to be_truthy }

    context "when same_organisation is blank" do
      let(:same_organisation) { "" }

      it { is_expected.to be_falsy }

      it "adds an error" do
        expect(form.errors[:same_organisation]).to eq(
          [
            "Select yes if they worked at the same organisation as you at the time of the alleged misconduct"
          ]
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
