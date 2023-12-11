require "rails_helper"

RSpec.describe FileUploadValidator do
  subject(:model) do
    instance = klass.new
    instance.files = files
    instance
  end

  let(:klass) do
    Class.new do
      include ActiveModel::Validations
      attr_accessor :files
      validates :files, file_upload: true
    end
  end

  context "with a valid file" do
    let(:files) { fixture_file_upload("upload1.pdf", "application/pdf") }

    it { is_expected.to be_valid }
  end

  context "with an invalid content type" do
    let(:files) { fixture_file_upload("upload.pl", "application/x-perl") }

    it { is_expected.not_to be_valid }
  end

  context "with an invalid extension" do
    let(:files) { fixture_file_upload("upload.txt", "application/pdf") }

    it { is_expected.not_to be_valid }
  end

  context "with a large file" do
    let(:files) { fixture_file_upload("upload1.pdf", "application/pdf") }

    before { allow(files).to receive(:size).and_return(51.megabytes) }

    it { is_expected.to be_invalid }
  end

  context "with too many files" do
    let(:files) do
      (described_class::MAX_FILES + 1).times.map do
        fixture_file_upload("upload1.pdf", "application/pdf")
      end
    end

    it { is_expected.to be_invalid }
  end

  it "supports selected media and document file types" do
    expect(described_class::CONTENT_TYPES.keys).to eq(
      %w[
        .apng
        .avif
        .doc
        .docx
        .eml
        .gif
        .heic
        .heif
        .jpg
        .jpeg
        .m4a
        .mov
        .mp3
        .mp4
        .msg
        .pdf
        .png
        .rtf
        .txt
        .webp
        .xlsx
      ]
    )
  end
end
