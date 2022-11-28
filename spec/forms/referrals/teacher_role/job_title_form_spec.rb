# frozen_string_literal: true
require "rails_helper"

RSpec.describe Referrals::TeacherRole::JobTitleForm, type: :model do
  subject(:form) { described_class.new(referral:, job_title:) }

  let(:referral) { build(:referral) }

  describe "#valid?" do
    subject(:valid) { form.valid? }

    before { valid }

    context "when job_title is not blank" do
      let(:job_title) { "Teacher" }

      it { is_expected.to be_truthy }
    end

    context "when job_title is blank" do
      let(:job_title) { "" }

      it { is_expected.to be_falsy }

      it "adds an error" do
        expect(form.errors[:job_title]).to eq(["Enter their job title"])
      end
    end
  end

  describe "#save" do
    subject(:save) { form.save }

    before { save }

    context "when job_title is present" do
      let(:job_title) { "Teacher" }

      it { is_expected.to be_truthy }

      it "saves job_title" do
        expect(referral.job_title).to eq("Teacher")
      end
    end

    context "when job_title is blank" do
      let(:job_title) { "" }

      it { is_expected.to be_falsy }
    end
  end
end
