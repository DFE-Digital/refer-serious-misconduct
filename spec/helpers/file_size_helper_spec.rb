require "rails_helper"

RSpec.describe FileSizeHelper, type: :helper do
  describe "#file_size" do
    subject { file_size(attachment) }

    context "when called with an attachment" do
      let(:attachment) { instance_double("ActiveStorage::Blob", byte_size: 33.6.kilobytes) }

      it { is_expected.to eq "33.6KB" }
    end
  end

  describe "#max_allowed_file_size" do
    subject { max_allowed_file_size }

    context "when called returns the max allowed file size human formatted with space removed" do
      it { is_expected.to eq "100MB" }
    end
  end
end
