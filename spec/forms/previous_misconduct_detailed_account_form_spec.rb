require "rails_helper"

RSpec.describe PreviousMisconductDetailedAccountForm, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:referral) }
    it do
      is_expected.to validate_inclusion_of(:format).in_array(
        %w[details incomplete]
      )
    end
    it { is_expected.not_to validate_presence_of(:details) }

    context "when format is details" do
      subject { described_class.new(format: "details") }

      it { is_expected.to validate_presence_of(:details) }
    end
  end

  describe "#valid?" do
    subject(:valid) { form.valid? }

    let(:details) { "true" }
    let(:form) { described_class.new(details:, format:, referral:) }
    let(:format) { "details" }
    let(:referral) { build(:referral) }

    it { is_expected.to be_truthy }

    context "when details is blank" do
      let(:details) { "" }

      it { is_expected.to be_falsy }
    end
  end

  describe "#format" do
    subject { form.format }

    let(:form) { described_class.new(format:, referral:) }
    let(:referral) { build(:referral) }

    context "when format is provided" do
      let(:format) { "details" }

      it { is_expected.to eq("details") }
    end

    context "when format is not provided and the referral has details" do
      let(:format) { nil }
      let(:referral) { build(:referral, previous_misconduct_details: "Text") }

      it { is_expected.to eq("details") }
    end

    context "when format is not provided and the referral has incomplete details" do
      let(:format) { nil }
      let(:referral) do
        build(
          :referral,
          previous_misconduct_details_incomplete_at: Time.current
        )
      end

      it { is_expected.to eq("incomplete") }
    end

    context "when format is not provided and the referral has an upload" do
      let(:format) { nil }
      let(:referral) do
        build(:referral).tap do |r|
          r.previous_misconduct_upload.attach io: Tempfile.new("test"),
                                              filename: "test",
                                              content_type: "text/plain"
        end
      end

      it { is_expected.to eq("upload") }
    end
  end

  describe "#save" do
    subject(:save) { form.save }

    let(:form) do
      described_class.new(details: "Previously", format:, referral:)
    end
    let(:format) { "details" }
    let(:referral) { build(:referral) }

    it "saves the Referral" do
      save
      expect(referral.previous_misconduct_details).to eq("Previously")
    end

    context "when format is incomplete" do
      let(:format) { "incomplete" }

      it "stores incomplete_at on the referral" do
        save
        expect(referral.previous_misconduct_details_incomplete_at).to be_present
      end
    end

    context "when previous_misconduct_details_incomplete_at is already set" do
      let(:referral) do
        build(
          :referral,
          previous_misconduct_details_incomplete_at: Time.current
        )
      end

      it "clears the incomplete value" do
        save
        expect(referral.previous_misconduct_details_incomplete_at).to be_nil
      end
    end
  end
end
