# frozen_string_literal: true
require "rails_helper"

RSpec.describe Referrals::TeacherRole::DutiesForm, type: :model do
  let(:referral) { create(:referral) }

  describe "#save" do
    subject(:save) { form.save }

    let(:duties_format) { nil }
    let(:duties_details) { nil }
    let(:duties_upload_file) { nil }
    let(:form) do
      described_class.new(referral:, duties_details:, duties_format:, duties_upload_file:)
    end

    context "with no duties format" do
      it { is_expected.to be_falsey }

      it "adds an error" do
        save
        expect(form.errors[:duties_format]).to eq(
          ["Select how you want to give details about their main duties"]
        )
      end
    end

    context "with upload format but no file" do
      let(:duties_format) { "upload" }

      it { is_expected.to be_falsey }

      it "adds an error" do
        save
        expect(form.errors[:duties_upload_file]).to eq(
          ["Select a file containing a description of their main duties"]
        )
      end
    end

    context "with upload format and file" do
      let(:duties_format) { "upload" }
      let(:duties_upload_file) { fixture_file_upload("upload1.pdf") }

      before { save }

      it { is_expected.to be_truthy }

      it "associates the upload with the referral" do
        expect(referral.duties_upload_file).to be_attached
      end

      it "updates details on the referral" do
        expect(referral.duties_details).to be nil
      end
    end

    context "with details format and no details" do
      let(:duties_format) { "details" }

      it { is_expected.to be_falsey }

      it "adds an error" do
        save
        expect(form.errors[:duties_details]).to eq(["Enter a description of their main duties"])
      end
    end

    context "with details format and details" do
      let(:duties_format) { "details" }
      let(:duties_details) { "Something something" }
      let(:duties_upload_file) { fixture_file_upload("upload1.pdf") }

      before { referral.uploads.create!(section: "duties", file: duties_upload_file) }

      it { is_expected.to be_truthy }

      it "updates details on the referral" do
        save
        expect(referral.reload.duties_details).to eq("Something something")
      end

      it "removes the previous upload from the referral" do
        save
        expect(referral.duties_upload_file).to be_nil
      end
    end
  end
end
