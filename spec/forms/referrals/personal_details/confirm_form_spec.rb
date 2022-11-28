# frozen_string_literal: true
require "rails_helper"

RSpec.describe Referrals::PersonalDetails::ConfirmForm, type: :model do
  describe "#save" do
    subject(:save) { confirm_form.save }

    let(:referral) { build(:referral) }
    let(:confirm_form) do
      described_class.new(referral:, personal_details_complete:)
    end
    let(:personal_details_complete) { false }

    context "with a valid value" do
      it "saves the value on the referral" do
        save
        expect(referral.personal_details_complete).to eq(false)
      end
    end

    context "with no values" do
      let(:personal_details_complete) { nil }

      it "adds an error" do
        save
        expect(confirm_form.errors[:personal_details_complete]).to eq(
          ["Tell us if you have completed this section"]
        )
      end
    end
  end
end
