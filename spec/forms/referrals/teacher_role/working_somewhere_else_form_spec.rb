# frozen_string_literal: true
require "rails_helper"

RSpec.describe Referrals::TeacherRole::WorkingSomewhereElseForm, type: :model do
  subject(:form) { described_class.new(referral:, working_somewhere_else:) }

  let(:referral) { build(:referral) }
  let(:working_somewhere_else) { "yes" }

  describe "#valid?" do
    subject(:valid) { form.valid? }

    before { valid }

    it { is_expected.to be_truthy }

    context "when working_somewhere_else is blank" do
      let(:working_somewhere_else) { "" }

      it { is_expected.to be_falsy }

      it "adds an error" do
        expect(form.errors[:working_somewhere_else]).to eq(["Select yes if they’re employed somewhere else"])
      end
    end
  end

  describe "#save" do
    context "when working_somewhere_else is yes" do
      let(:working_somewhere_else) { "yes" }

      it "updates the working_somewhere_else to yes" do
        expect { form.save }.to change(referral, :working_somewhere_else).from(nil).to("yes")
      end
    end

    context "when working_somewhere_else is no" do
      let(:working_somewhere_else) { "no" }

      it "updates the working_somewhere_else to no" do
        expect { form.save }.to change(referral, :working_somewhere_else).from(nil).to("no")
      end
    end

    context "when working_somewhere_else is not known" do
      let(:working_somewhere_else) { "not_sure" }

      it "updates the working_somewhere_else to not_sure" do
        expect { form.save }.to change(referral, :working_somewhere_else).from(nil).to("not_sure")
      end
    end
  end
end
