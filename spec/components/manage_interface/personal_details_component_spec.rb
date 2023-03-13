require "rails_helper"

RSpec.describe ManageInterface::PersonalDetailsComponent, type: :component do
  subject(:rendered) { render_inline(described_class.new(referral:)) }

  context "when public referral" do
    let(:referral) { create(:referral, :personal_details_public) }

    it "renders the correct data" do
      expect(rendered.css("div dl div dt")[0].text).to eq("First name")
      expect(rendered.css("div dl div dd")[0].text).to eq("John")
      expect(rendered.css("div dl div dt")[1].text).to eq("Last name")
      expect(rendered.css("div dl div dd")[1].text).to eq("Smith")
      expect(rendered.css("div dl div dt")[2].text).to eq(
        "Do you know them by any other name?"
      )
      expect(rendered.css("div dl div dd")[2].text).to eq("No")
    end
  end
end
