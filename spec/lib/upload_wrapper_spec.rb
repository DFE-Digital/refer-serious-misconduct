require "rails_helper"

RSpec.describe UploadWrapper do
  describe "#as_json" do
    subject(:upload_wrapper) do
      described_class.new(upload:)
    end

    let(:upload) { file_fixture("upload1.pdf") }

    it "includes file size" do
      expect(upload_wrapper.as_json[:file_size]).to eql("4.98 KB")
    end
  end
end
