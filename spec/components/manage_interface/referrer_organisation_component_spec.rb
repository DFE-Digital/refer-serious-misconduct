require "rails_helper"

RSpec.describe ManageInterface::ReferrerOrganisationComponent, type: :component do
  subject(:component) { described_class.new(referral:) }

  let(:row_labels) { component.rows.map { |row| row.dig(:key, :text) } }
  let(:row_values) { component.rows.map { |row| row.dig(:value, :text) }.map(&:strip) }
  let(:row_values_sanitized) do
    row_values.map { |value| ActionView::Base.full_sanitizer.sanitize(value) }
  end
  let(:referral) { create(:referral, :employer_complete) }

  before { render_inline(component) }

  it "renders the correct labels" do
    expect(row_labels).to eq(["Organisation"])
  end

  it "renders the correct values" do
    expect(row_values_sanitized).to eq(
      ["Different School2 Different StreetSame RoadExample TownW1 1AA"]
    )
  end
end
