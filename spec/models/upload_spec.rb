require "rails_helper"

RSpec.describe Upload, type: :model do
  let(:upload) { create(:upload, :evidence) }

  it { is_expected.to belong_to(:uploadable) }
  it { is_expected.to have_one_attached(:file) }

  describe "#save_filename" do
    subject { upload.filename }

    it { is_expected.to eq("upload1.pdf") }
  end
end
