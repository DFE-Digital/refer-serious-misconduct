require "rails_helper"

RSpec.describe RenderPdfJob do
  let(:referral) { create(:referral, :complete, :with_attachments) }

  describe "generating the HTML" do
    let(:job) { described_class.new }

    it "renders the html and removes the a tags" do
      job.perform(referral:)

      expect(job.send(:html)).to match(%r{<dd.*?><a.*?>upload1.pdf</a></dd>})
      expect(job.send(:processed_html)).to match(%r{<dd.*?>upload1.pdf</dd>})
    end
  end

  describe "running the job" do
    subject(:perform) { described_class.new.perform(referral:) }

    around do |example|
      ClimateControl.modify HOSTING_DOMAIN: "https://example.com" do
        example.run
      end
    end

    before do
      allow(ActionController::Base.helpers).to receive(:asset_path).with(
        "main.css"
      ).and_return("/1234-main.css")
      allow(ActionController::Base.helpers).to receive(:asset_path).with(
        "tra_logo.png"
      ).and_return("/images/1234-tra_logo.png")
    end

    it "attaches a PDF to the referral" do
      perform
      expect(referral.pdf.filename).to eq("referral-#{referral.id}.pdf")
    end

    it "specifies the correct assets" do
      allow(ApplicationController.renderer).to receive(:new).and_return(
        renderer = double
      )

      expect(renderer).to receive(:render).with(
        hash_including(
          assigns: {
            stylesheet: "https://example.com/1234-main.css",
            logo: "https://example.com/images/1234-tra_logo.png"
          }
        )
      )
      perform
    end
  end
end
