require "rails_helper"

RSpec.describe UploadWrapper do
  describe "#as_json" do
    subject(:upload_wrapper) do
      described_class.new(upload:, count:)
    end

    let(:upload) { file_fixture("upload1.pdf") }
    let(:count) { 4 }

    it "includes file size" do
      expect(upload_wrapper.as_json[:file_size]).to eql("4.98 KB")
    end

    it "includes the count" do
      expect(upload_wrapper.as_json[:files_with_errors_count]).to be(4)
    end
  end
end
