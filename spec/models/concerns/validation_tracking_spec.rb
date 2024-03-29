require "rails_helper"

RSpec.describe ValidationTracking do
  let(:klass) do
    Class.new do
      include ActiveModel::Model
      include ValidationTracking

      attr_accessor :evidence_uploads

      validate :field_with_meta_options

      def self.model_name
        ActiveModel::Name.new(self, nil, "referrals/allegation_evidence/upload_form")
      end

      def self.name
        "Referrals::AllegationEvidence::UploadForm"
      end

      def field_with_meta_options
        errors.add(:evidence_uploads, :file_size_too_big, max_allowed_file_size: "50MB")
      end
    end
  end

  describe "#track_validation_error" do
    context "when an uploaded file" do
      subject(:instance) do
        klass.new(evidence_uploads: [ActionDispatch::Http::UploadedFile.new(tempfile: file_fixture("upload1.pdf"))])
      end

      it "persists the file size" do
        expect {
          instance.valid?
        }.to change(ValidationError, :count).by(1)

        expect(ValidationError.last.details.dig("evidence_uploads", "value", 0, "file_size")).to eql("4.98 KB")
      end
    end

    context "when an uploaded file is over maximum size" do
      subject(:instance) do
        klass.new(evidence_uploads: [ActionDispatch::Http::UploadedFile.new(tempfile: file_fixture("upload1.pdf"))])
      end

      it "persists the count of files over the max size" do
        stub_const("FileUploadValidator::MAX_FILE_SIZE", 1.kilobyte)
        expect {
          instance.valid?
        }.to change(ValidationError, :count).by(1)
        expect(ValidationError.last.details.dig("evidence_uploads", "value", 0, "files_with_errors_count")).to be(1)
      end
    end

    context "when multiple files are uploaded together and one is over the maximum size" do
      subject(:instance) do
        klass.new(evidence_uploads: [ActionDispatch::Http::UploadedFile.new(tempfile: file_fixture("upload1.pdf")),
                                     ActionDispatch::Http::UploadedFile.new(tempfile: file_fixture("upload.txt"))])
      end

      it "persists the count of files over the max size" do
        stub_const("FileUploadValidator::MAX_FILE_SIZE", 1.kilobyte)
        expect {
          instance.valid?
        }.to change(ValidationError, :count).by(1)
        expect(ValidationError.last.details.dig("evidence_uploads", "value", 0, "files_with_errors_count")).to be(1)
      end
    end

    context "when multiple uploaded files are over maximum size" do
      subject(:instance) do
        klass.new(evidence_uploads: [ActionDispatch::Http::UploadedFile.new(tempfile: file_fixture("upload1.pdf")),
                                     ActionDispatch::Http::UploadedFile.new(tempfile: file_fixture("upload2.pdf"))])
      end

      it "persists the count of files over the max size" do
        stub_const("FileUploadValidator::MAX_FILE_SIZE", 1.kilobyte)
        expect {
          instance.valid?
        }.to change(ValidationError, :count).by(1)
        expect(ValidationError.last.details.dig("evidence_uploads", "value", 0, "files_with_errors_count")).to be(2)
      end
    end
  end
end
