require "rails_helper"

RSpec.describe FileUploadValidator do
  subject(:model) { Validatable.new }

  let(:files) { nil }

  before do
    stub_const("Validatable", Class.new).class_eval do
      include ActiveModel::Validations
      attr_accessor :files
      validates :files, file_upload: true
    end
    model.files = files
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

    before { allow(files).to receive(:size).and_return(101.megabytes) }

    it { is_expected.to be_invalid }
  end

  context "with too many files" do
    let(:files) do
      [
        fixture_file_upload("upload1.pdf", "application/pdf"),
        fixture_file_upload("upload1.pdf", "application/pdf"),
        fixture_file_upload("upload1.pdf", "application/pdf"),
        fixture_file_upload("upload1.pdf", "application/pdf"),
        fixture_file_upload("upload1.pdf", "application/pdf"),
        fixture_file_upload("upload1.pdf", "application/pdf"),
        fixture_file_upload("upload1.pdf", "application/pdf"),
        fixture_file_upload("upload1.pdf", "application/pdf"),
        fixture_file_upload("upload1.pdf", "application/pdf"),
        fixture_file_upload("upload1.pdf", "application/pdf"),
        fixture_file_upload("upload1.pdf", "application/pdf")
      ]
    end

    it { is_expected.to be_invalid }
  end

  it "supports common media and document file types" do
    expect(described_class::CONTENT_TYPES.keys).to eq(
      %w[.apng .avif .doc .docx .gif .heic .heif .jpg .jpeg .mp3 .mp4 .mov .pdf .png .txt .webp]
    )
  end
end
