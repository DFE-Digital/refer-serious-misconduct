# frozen_string_literal: true
require "rails_helper"

RSpec.describe Referrals::TeacherRole::OrganisationAddressKnownForm, type: :model do
  subject(:form) { described_class.new(referral:, organisation_address_known:) }

  let(:referral) { build(:referral) }
  let(:organisation_address_known) { true }

  describe "#valid?" do
    subject(:valid) { form.valid? }

    before { valid }

    it { is_expected.to be_truthy }

    context "when organisation_address_known is blank" do
      let(:organisation_address_known) { "" }

      it { is_expected.to be_falsy }

      it "adds an error" do
        expect(form.errors[:organisation_address_known]).to eq(
          ["Select yes if you know the name and address of the organisation"]
        )
      end
    end
  end

  describe "#save" do
    context "when organisation_address_known is true" do
      let(:organisation_address_known) { "true" }

      it "updates the organisation_address_known to true" do
        expect { form.save }.to change(referral, :organisation_address_known).from(nil).to(true)
      end
    end

    context "when organisation_address_known is false" do
      let(:organisation_address_known) { false }

      it "updates the organisation_address_known to false" do
        expect { form.save }.to change(referral, :organisation_address_known).from(nil).to(false)
      end
    end
  end
end
