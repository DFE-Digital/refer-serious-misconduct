# frozen_string_literal: true
require "rails_helper"

RSpec.describe Referrals::TeacherRole::TeachingSomewhereElseForm,
               type: :model do
  subject(:form) { described_class.new(referral:, teaching_somewhere_else:) }

  let(:referral) { build(:referral) }
  let(:teaching_somewhere_else) { "yes" }

  describe "#valid?" do
    subject(:valid) { form.valid? }

    before { valid }

    it { is_expected.to be_truthy }

    context "when teaching_somewhere_else is blank" do
      let(:teaching_somewhere_else) { "" }

      it { is_expected.to be_falsy }

      it "adds an error" do
        expect(form.errors[:teaching_somewhere_else]).to eq(
          ["Tell us if you know if they are teaching somewhere else"]
        )
      end
    end
  end

  describe "#save" do
    context "when teaching_somewhere_else is yes" do
      let(:teaching_somewhere_else) { "yes" }

      it "updates the teaching_somewhere_else to yes" do
        expect { form.save }.to change(referral, :teaching_somewhere_else).from(
          nil
        ).to("yes")
      end
    end

    context "when teaching_somewhere_else is no" do
      let(:teaching_somewhere_else) { "no" }

      it "updates the teaching_somewhere_else to no" do
        expect { form.save }.to change(referral, :teaching_somewhere_else).from(
          nil
        ).to("no")
      end
    end

    context "when teaching_somewhere_else is not known" do
      let(:teaching_somewhere_else) { "dont_know" }

      it "updates the teaching_somewhere_else to dont_know" do
        expect { form.save }.to change(referral, :teaching_somewhere_else).from(
          nil
        ).to("dont_know")
      end
    end
  end
end
