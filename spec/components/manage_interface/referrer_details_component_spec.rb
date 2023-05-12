require "rails_helper"

RSpec.describe ManageInterface::ReferrerDetailsComponent, type: :component do
  subject(:component) { described_class.new(referral:) }

  let(:row_labels) { component.rows.map { |row| row.dig(:key, :text) } }
  let(:row_values) { component.rows.map { |row| row.dig(:value, :text) }.map(&:strip) }
  let(:row_values_sanitized) do
    row_values.map { |value| ActionView::Base.full_sanitizer.sanitize(value) }
  end
  let(:user) { create(:user, email: "test@example.com") }

  before { render_inline(component) }

  context "with an employer referral" do
    let(:referral) { create(:referral, :employer_complete, user:) }

    it "renders the correct labels" do
      expect(row_labels).to eq(
        [
          "First name",
          "Last name",
          "Job title",
          "Type",
          "Email address",
          "Phone number",
          "Employer"
        ]
      )
    end

    it "renders the correct values" do
      expect(row_values_sanitized).to eq(
        [
          "Jane",
          "Smith",
          "Headteacher",
          "Employer",
          "test@example.com",
          "01234567890",
          "Example School1 Example StreetExample CityW1 1AA"
        ]
      )
    end
  end

  context "with a public referral" do
    let(:referral) { create(:referral, :public_complete, user:) }

    it "renders the correct labels" do
      expect(row_labels).to eq(["First name", "Last name", "Type", "Email address", "Phone number"])
    end

    it "renders the correct values" do
      expect(row_values).to eq(%w[Jane Smith Public test@example.com 01234567890])
    end
  end
end
