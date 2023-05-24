require "rails_helper"

RSpec.describe Referrals::PersonalDetails::NameForm do
  describe "#save" do
    subject(:save) { form.save }

    let(:form) { described_class.new(params) }
    let(:params) { { referral: } }
    let(:referral) { build(:referral) }

    before { save }

    context "with valid values" do
      let(:params) do
        {
          first_name: "Jane",
          last_name: "Smith",
          name_has_changed: "yes",
          previous_name: "Janet Jones",
          referral:
        }
      end

      it "saves the first_name" do
        expect(referral.first_name).to eq("Jane")
      end

      it "saves the last_name" do
        expect(referral.last_name).to eq("Smith")
      end

      it "saves the name_has_changed" do
        expect(referral.name_has_changed).to eq("yes")
      end

      it "saves the previous_name" do
        expect(referral.previous_name).to eq("Janet Jones")
      end
    end

    context "when first name is blank" do
      it "raises an error on first name" do
        expect(form.errors[:first_name]).to include "Enter their first name"
      end
    end

    context "when last name is blank" do
      it "raises an error on last name" do
        expect(form.errors[:last_name]).to include "Enter their last name"
      end
    end

    context "when name_has_changed is blank" do
      it "raises an error on name has changed" do
        expect(form.errors[:name_has_changed]).to include(
          "Select yes if you know them by any other name"
        )
      end
    end

    context "when name has changed is yes" do
      let(:params) { { name_has_changed: "yes", referral: } }

      it "raises an error on previous name" do
        expect(form.errors[:previous_name]).to include("Enter their other name")
      end
    end
  end
end
