require "rails_helper"

module Referrals
  class TestSection < Section
    def items
      [ReferrerOrganisation::AddressForm.new(referral:)]
    end

    def complete?
      false
    end

    def slug
      :test_section
    end
  end

  RSpec.describe TestSection, type: :model do
    let(:referral) { create(:referral) }

    let(:section) { described_class.new(referral:) }

    describe "#label" do
      subject(:label) { section.label }

      it "returns the correct label from the translation file" do
        allow(I18n).to receive(:t).with("referral_form.test_section").and_return(
          "Test Section Label"
        )
        expect(label).to eq "Test Section Label"
      end
    end

    describe "#start_path" do
      subject(:start_path) { section.start_path }

      it "returns the path for the first item" do
        expect(start_path).to eq [
             :edit,
             referral.routing_scope,
             referral,
             :referrer_organisation_address
           ]
      end
    end

    describe "#check_answers_path" do
      subject(:check_answers_path) { section.check_answers_path }

      it "returns the path for the check answers page" do
        expect(check_answers_path).to eq [
             :edit,
             referral.routing_scope,
             referral,
             :test_section,
             :check_answers
           ]
      end
    end

    describe "#path" do
      subject(:path) { section.path }

      context "when the section is not started" do
        it "returns the start path" do
          allow(section).to receive(:started?).and_return(false)
          allow(section).to receive(:start_path).and_return(:start_path)
          expect(path).to eq :start_path
        end
      end

      context "when the section is started" do
        it "returns the check answers path" do
          allow(section).to receive(:started?).and_return(true)
          allow(section).to receive(:check_answers_path).and_return(:check_answers_path)

          expect(path).to eq :check_answers_path
        end
      end
    end

    describe "#next_path" do
      subject(:next_path) { section.next_path }

      it "returns the path for the next incomplete item" do
        expect(next_path).to eq [:edit, nil, referral, :referrer_organisation_address]
      end
    end

    describe "#questions_complete?" do
      subject(:questions_complete?) { section.questions_complete? }

      it "returns true if all items except last are complete" do
        allow(section).to receive(:items).and_return(
          [
            instance_double(ReferrerOrganisation::AddressForm, complete?: true),
            instance_double(ReferrerOrganisation::AddressForm, complete?: true),
            instance_double(ReferrerOrganisation::AddressForm, complete?: false)
          ]
        )
        expect(questions_complete?).to be true
      end

      it "returns false if any item except last is incomplete" do
        allow(section).to receive(:items).and_return(
          [
            instance_double(ReferrerOrganisation::AddressForm, complete?: true),
            instance_double(ReferrerOrganisation::AddressForm, complete?: false),
            instance_double(ReferrerOrganisation::AddressForm, complete?: false)
          ]
        )
        expect(questions_complete?).to be false
      end
    end
  end
end
