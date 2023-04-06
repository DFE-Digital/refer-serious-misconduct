require "rails_helper"

RSpec.describe ManageInterface::AllegationDetailsComponent, type: :component do
  subject(:component) { described_class.new(referral:) }

  let(:row_labels) { component.rows.map { |row| row.dig(:key, :text) } }
  let(:row_values) { component.rows.map { |row| row.dig(:value, :text) }.map(&:strip) }
  let(:row_values_sanitized) do
    row_values.map { |value| ActionView::Base.full_sanitizer.sanitize(value) }
  end

  before { render_inline(component) }

  context "with an employer referral" do
    let(:referral) { create(:referral, :employer_complete) }

    it "renders the correct labels" do
      expect(row_labels).to eq(
        [
          "How do you want to give details about the allegation?",
          "Allegation details",
          "Have you told the Disclosure and Barring Service (DBS)?"
        ]
      )
    end

    it "renders the correct values" do
      expect(row_values_sanitized).to eq(
        ["Describe the allegation", "They were rude to a child", "Yes"]
      )
    end
  end

  context "with a public referral" do
    let(:referral) do
      create(:referral, :public_complete, allegation_consideration_details: "Considered")
    end

    it "renders the correct labels" do
      expect(row_labels).to eq(
        [
          "How do you want to give details about the allegation?",
          "Allegation details",
          "Details about how this complaint has been considered"
        ]
      )
    end

    it "renders the correct values" do
      expect(row_values_sanitized).to eq(
        ["Describe the allegation", "They were rude to a child", "Considered"]
      )
    end
  end
end
