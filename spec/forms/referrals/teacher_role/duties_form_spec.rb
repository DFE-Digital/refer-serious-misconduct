# frozen_string_literal: true
require "rails_helper"

RSpec.describe Referrals::TeacherRole::DutiesForm, type: :model do
  let(:referral) { build(:referral) }

  describe "#save" do
    subject(:save) { form.save }

    let(:duties_format) { nil }
    let(:duties_details) { nil }
    let(:duties_upload) { nil }
    let(:form) { described_class.new(referral:, duties_details:, duties_format:, duties_upload:) }

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
        expect(form.errors[:duties_upload]).to eq(
          ["Select a file containing a description of their main duties"]
        )
      end
    end

    context "with upload format and file" do
      let(:duties_format) { "upload" }
      let(:duties_upload) { fixture_file_upload("upload1.pdf") }

      it { is_expected.to be_truthy }

      it "associates the upload with the referral" do
        save
        expect(referral.duties_upload).to be_attached
      end

      it "updates details on the referral" do
        save
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

      it { is_expected.to be_truthy }

      it "updates details on the referral" do
        save
        expect(referral.reload.duties_details).to eq("Something something")
      end

      context "when there is an existing upload" do
        before { referral.duties_upload.attach(fixture_file_upload("upload1.pdf")) }

        it "has the attached file" do
          expect(referral.duties_upload).to be_attached
        end

        it "updates details on the referral" do
          save
          expect(referral.reload.duties_details).to eq("Something something")
        end

        it "purges the attached file" do
          save
          expect(referral.duties_upload).not_to be_attached
        end
      end
    end
  end
end
