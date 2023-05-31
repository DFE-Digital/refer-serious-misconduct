require "rails_helper"

RSpec.describe ManageInterface::AllegationPreviousMisconductComponent, type: :component do
  subject(:component) { described_class.new(referral:) }

  let(:row_labels) { component.rows.map { |row| row.dig(:key, :text) } }
  let(:row_values) { component.rows.map { |row| row.dig(:value, :text) }.map(&:strip) }
  let(:row_values_sanitized) do
    row_values.map { |value| ActionView::Base.full_sanitizer.sanitize(value) }
  end
  let(:referral) { create(:referral, :employer_complete) }

  before { render_inline(component) }

  it "renders the correct labels" do
    expect(row_labels).to eq(
      ["How do you want to give details about previous allegations?", "Previous allegation details"]
    )
  end

  it "renders the correct values" do
    expect(row_values_sanitized).to eq(["Describe the allegation", "They were rude to a child"])
  end

  context "when a previous misconduct was not reported" do
    let(:referral) { create(:referral, :employer_complete, previous_misconduct_reported: "false") }

    it "renders 'Has there been any previous misconduct?' too" do
      expect(row_labels[0]).to eq("Has there been any previous misconduct?")
      expect(row_values_sanitized[0]).to eq("No")
    end
  end
end
