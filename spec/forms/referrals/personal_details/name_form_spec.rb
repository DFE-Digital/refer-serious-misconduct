require "rails_helper"

RSpec.describe Referrals::PersonalDetails::NameForm do
  describe "#save (names)" do
    let(:referral) { build(:referral) }
    let(:first_name) { "Jane" }
    let(:last_name) { "Smith" }
    let(:name_has_changed) { "yes" }
    let(:previous_name) { "Janet Jones" }

    subject(:form) do
      described_class.new(
        referral:,
        first_name:,
        last_name:,
        name_has_changed:,
        previous_name:
      )
    end

    context "with valid values" do
      it "updates the names on the referral record" do
        form.save

        expect(referral.first_name).to eq("Jane")
        expect(referral.last_name).to eq("Smith")
        expect(referral.name_has_changed).to eq("yes")
        expect(referral.previous_name).to eq("Janet Jones")
      end
    end

    context "with invalid values" do
      let(:first_name) { "" }
      let(:last_name) { "" }
      let(:name_has_changed) { "" }
      let(:previous_name) { "" }

      it "fails form validation" do
        form.save

        expect(form.errors[:first_name]).to include "First name can't be blank"
        expect(form.errors[:last_name]).to include "Last name can't be blank"
        expect(form.errors[:name_has_changed]).to include(
          "Tell us if you know their name has changed"
        )
      end

      it "validates previous name conditionally" do
        form.name_has_changed = "yes"
        form.save
        expect(
          form.errors[:previous_name]
        ).to include "Previous name can't be blank"
      end
    end
  end
end
