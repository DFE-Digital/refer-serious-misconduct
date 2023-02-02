require "rails_helper"

RSpec.describe Referrals::PreviousMisconduct::DetailedAccountForm,
               type: :model do
  let(:referral) { build(:referral) }

  describe "validations" do
    subject(:form) { described_class.new(referral:) }

    it { is_expected.to validate_presence_of(:referral) }

    specify do
      expect(form).to validate_inclusion_of(
        :previous_misconduct_format
      ).in_array(%w[details upload])
    end

    it { is_expected.not_to validate_presence_of(:previous_misconduct_details) }

    context "when format is details" do
      subject { described_class.new(previous_misconduct_format: "details") }

      it { is_expected.to validate_presence_of(:previous_misconduct_details) }
    end
  end

  describe "#valid?" do
    subject(:valid) { form.valid? }

    let(:previous_misconduct_details) { "true" }
    let(:previous_misconduct_format) { "details" }
    let(:form) do
      described_class.new(
        previous_misconduct_details:,
        previous_misconduct_format:,
        referral:
      )
    end

    it { is_expected.to be_truthy }

    context "when details is blank" do
      let(:previous_misconduct_details) { "" }

      it { is_expected.to be_falsy }
    end
  end

  describe "#save" do
    subject(:save) { form.save }

    let(:previous_misconduct_format) { nil }
    let(:previous_misconduct_details) { nil }
    let(:previous_misconduct_upload) { nil }
    let(:form) do
      described_class.new(
        referral:,
        previous_misconduct_details:,
        previous_misconduct_format:,
        previous_misconduct_upload:
      )
    end

    context "without previous misconduct format" do
      it { is_expected.to be_falsey }

      it "adds an error" do
        save
        expect(form.errors[:previous_misconduct_format]).to eq(
          ["Select how you want to give details about previous allegations"]
        )
      end
    end

    context "with upload format but no file" do
      let(:previous_misconduct_format) { "upload" }

      it { is_expected.to be_falsey }

      it "adds an error" do
        save
        expect(form.errors[:previous_misconduct_upload]).to eq(
          ["Select a file containing details of previous allegations"]
        )
      end
    end

    context "with upload format and file" do
      let(:previous_misconduct_format) { "upload" }
      let(:previous_misconduct_upload) { fixture_file_upload("upload1.pdf") }

      it { is_expected.to be_truthy }

      it "associates the upload with the referral" do
        save
        expect(referral.previous_misconduct_upload).to be_attached
      end

      it "updates details on the referral" do
        save
        expect(referral.previous_misconduct_details).to be nil
      end
    end

    context "with details format and no details" do
      let(:previous_misconduct_format) { "details" }

      it { is_expected.to be_falsey }

      it "adds an error" do
        save
        expect(form.errors[:previous_misconduct_details]).to eq(
          ["Enter a description of previous allegations"]
        )
      end
    end

    context "with details format and details" do
      let(:previous_misconduct_format) { "details" }
      let(:previous_misconduct_details) { "Something something" }

      it { is_expected.to be_truthy }

      it "updates details on the referral" do
        save
        expect(referral.reload.previous_misconduct_details).to eq(
          "Something something"
        )
      end

      context "when there is an existing upload" do
        before do
          referral.previous_misconduct_upload.attach(
            fixture_file_upload("upload1.pdf")
          )
        end

        it "has the attached file" do
          expect(referral.previous_misconduct_upload).to be_attached
        end

        it "updates details on the referral" do
          save
          expect(referral.reload.previous_misconduct_details).to eq(
            "Something something"
          )
        end

        it "purges the attached file" do
          save
          expect(referral.previous_misconduct_upload).not_to be_attached
        end
      end
    end
  end
end
