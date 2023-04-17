require "rails_helper"

RSpec.describe ManageInterface::ReferralComponent, type: :component do
  subject(:component) { described_class.new(referral:) }

  let(:row_labels) { component.rows.map { |row| row.dig(:key, :text) } }
  let(:row_values) { component.rows.map { |row| row.dig(:value, :text) }.map(&:strip) }
  let(:referral) do
    create(
      :referral,
      :complete,
      :personal_details_employer,
      submitted_at: Time.zone.local(2022, 11, 22, 12, 0, 0)
    )
  end

  before { render_inline(component) }

  it "renders the correct labels" do
    expect(row_labels).to eq(["Referral date", "Referrer"])
  end

  it "renders the correct values" do
    expect(row_values).to eq(["22 November 2022 at 12:00 pm", "Jane Smith"])
  end

  describe "#title" do
    it "returns the correct title" do
      expect(component.title).to eq("John Smith")
    end
  end
end
