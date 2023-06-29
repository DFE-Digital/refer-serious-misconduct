require "rails_helper"

describe ReferralZipFile do
  let(:referral_zip_file) { described_class.new(referral) }

  before { travel_to Time.zone.local(2022, 11, 22, 12, 0, 0) }

  describe "#path" do
    let(:referral) { create(:referral, :with_attachments) }

    it "returns the generated file path" do
      expect(Pathname.new(referral_zip_file.path)).to be_file
    end
  end

  describe "zip file contents" do
    let(:zip_path) { referral_zip_file.path }
    let(:zip_contents) { Zip::File.open(zip_path) { |zip| zip.entries.map(&:name) } }

    context "with a pdf" do
      let(:referral) { create(:referral, :with_pdf) }

      it "includes the pdf in the root" do
        expect(zip_contents).to match_array("#{referral.id}-referral.pdf")
      end
    end

    context "with a clean attachment" do
      let(:referral) { create(:referral, :with_clean_attachment) }

      it "includes the attachment in a folder named by section" do
        expect(zip_contents).to match_array("allegation/#{referral.id}-upload1.pdf")
      end
    end

    context "with a pending attachment" do
      let(:referral) { create(:referral, :with_pending_attachment) }

      it "includes a text file warning that the file is pending" do
        attachment_filepath =
          "allegation/#{referral.id}-upload1.pdf-file-being-checked-for-viruses.txt"
        expect(zip_contents).to include(attachment_filepath)
      end
    end

    context "with a suspect attachment" do
      let(:referral) { create(:referral, :with_suspect_attachment) }

      it "includes a text file warning that the file is suspect" do
        attachment_filepath =
          "allegation/#{referral.id}-upload1.pdf-file-removed-due-to-suspected-virus.txt"
        expect(zip_contents).to include(attachment_filepath)
      end
    end
  end

  describe "#name" do
    let(:referral) { create(:referral) }

    it "returns the file name" do
      expect(referral_zip_file.name).to eq("20221122120000-referral-#{referral.id}.zip")
    end
  end

  describe "#has_attachments?" do
    context "when the referral doesn't have attached files" do
      let(:referral) { create(:referral) }

      it "returns false" do
        expect(referral_zip_file).not_to have_attachments
      end
    end

    context "when the referral has attached files" do
      let(:referral) { create(:referral, :with_attachments) }

      it "returns true" do
        expect(referral_zip_file).to have_attachments
      end
    end

    context "when the referral has a pdf attachment" do
      let(:referral) { create(:referral, :with_pdf) }

      it "returns true" do
        expect(referral_zip_file).to have_attachments
      end
    end

    context "with suspect attachment" do
      let(:referral) { create(:referral, :with_suspect_attachment) }

      it "returns false" do
        expect(referral_zip_file).to have_attachments
      end
    end

    context "with pending attachment" do
      let(:referral) { create(:referral, :with_pending_attachment) }

      it "returns false" do
        expect(referral_zip_file).to have_attachments
      end
    end
  end
end
