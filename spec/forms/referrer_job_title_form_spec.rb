require "rails_helper"

RSpec.describe ReferrerJobTitleForm, type: :model do
  let(:referral) { build(:referral, referrer:) }
  let(:referrer) { build(:referrer) }

  describe "validations" do
    subject { described_class.new(referral:) }

    it { is_expected.to validate_presence_of(:referral) }
    it { is_expected.to validate_presence_of(:job_title) }
  end

  describe "#valid?" do
    subject(:valid) { form.valid? }

    let(:form) { described_class.new(referral:, job_title:) }
    let(:job_title) { "Job Title" }
    let(:referral) { build(:referral, referrer:) }
    let(:referrer) { build(:referrer) }

    it { is_expected.to be_truthy }
  end

  describe "#save" do
    subject(:save) { form.save }

    let(:form) { described_class.new(referral:, job_title:) }
    let(:job_title) { "Job Title" }
    let(:referral) { build(:referral, referrer:) }
    let(:referrer) { build(:referrer) }

    it "saves the referral" do
      save
      expect(referrer.job_title).to eq(job_title)
    end

    context "with an invalid form" do
      let(:job_title) { nil }

      it { is_expected.to be_falsey }
    end
  end
end
