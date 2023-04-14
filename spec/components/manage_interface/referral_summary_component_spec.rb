require "rails_helper"

RSpec.describe ManageInterface::ReferralSummaryComponent, type: :component do
  subject(:component) { described_class.new(referral:) }

  let(:row_labels) { component.rows.map { |row| row.dig(:key, :text) } }
  let(:row_values) { component.rows.map { |row| row.dig(:value, :text) } }

  let(:referral) { create(:referral, :employer_complete) }

  before { render_inline(component) }

  it "renders the correct labels" do
    expect(row_labels).to eq(["Referral ID", "Referral date"])
  end

  it "renders the correct values" do
    expect(row_values).to eq([referral.id, referral.created_at.to_fs(:day_month_year_time)])
  end
end
