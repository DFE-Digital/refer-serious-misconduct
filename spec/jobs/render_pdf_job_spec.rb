require "rails_helper"

RSpec.describe RenderPdfJob do
  let(:referral) { create(:referral, :complete, :with_attachments) }

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
    end

    it "attaches a PDF to the referral" do
      perform
      expect(referral.pdf.filename).to eq("referral-#{referral.id}.pdf")
    end

    it "specifies the correct stylesheet" do
      allow(ApplicationController.renderer).to receive(:new).and_return(
        renderer = double
      )

      expect(renderer).to receive(:render).with(
        hash_including(
          assigns: {
            stylesheet: "https://example.com/1234-main.css"
          }
        )
      )
      perform
    end
  end
end
