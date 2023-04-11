require "rails_helper"
require "action_view"

RSpec.describe PublicAllegationComponent, type: :component do
  subject(:component) { described_class.new(referral:) }

  let(:referrer) { referral.referrer }

  let(:row_labels) { component.rows.map { |row| row.dig(:key, :text) } }
  let(:row_values) { component.rows.map { |row| row.dig(:value, :text) }.map(&:strip) }
  let(:row_values_sanitized) do
    row_values.map { |value| ActionView::Base.full_sanitizer.sanitize(value) }
  end
  let(:row_links) { component.rows.map { |row| row.dig(:actions, :href) } }
  let(:allegation_format) { nil }
  let(:allegation_details) { nil }
  let(:allegation_upload) { nil }
  let(:allegation_consideration_details) { nil }

  let(:referral) do
    create(
      :referral,
      :complete,
      :public,
      allegation_format:,
      allegation_details:,
      allegation_upload:,
      allegation_consideration_details:
    )
  end

  before { render_inline(component) }

  it "renders the labels" do
    expect(row_labels).to eq(
      [
        "How do you want to give details about the allegation?",
        "Description of the allegation",
        "Details about how this complaint has been considered"
      ]
    )
  end

  it "renders the values" do
    expect(row_values_sanitized).to eq(["Not answered", "Not answered", "Not answered"])
  end

  it "renders the Change links" do
    expect(row_links).to eq(
      [
        "/public-referrals/#{referral.id}/allegation/details/edit?return_to=%2F",
        "/public-referrals/#{referral.id}/allegation/details/edit?return_to=%2F",
        "/public-referrals/#{referral.id}/allegation/considerations/edit?return_to=%2F"
      ]
    )
  end

  context "with a description" do
    let(:allegation_format) { "details" }
    let(:allegation_details) { "They were rude to a child" }

    it "renders the correct values" do
      expect(row_values_sanitized).to eq(
        ["Describe the allegation", "They were rude to a child", "Not answered"]
      )
    end
  end

  context "with an upload" do
    let(:allegation_format) { "upload" }
    let(:allegation_upload) do
      Rack::Test::UploadedFile.new(
        Rails.root.join("spec/fixtures/files/upload1.pdf"),
        "application/pdf"
      )
    end

    it "renders the correct values" do
      expect(row_values_sanitized).to eq(["Upload file", "upload1.pdf", "Not answered"])
    end
  end

  context "with a consideration" do
    let(:allegation_consideration_details) { "Please take into consideration" }

    it "renders the correct values" do
      expect(row_values_sanitized).to eq(
        ["Not answered", "Not answered", "Please take into consideration"]
      )
    end
  end

  context "when referral is submitted" do
    let(:referral) do
      create(
        :referral,
        :complete,
        :submitted,
        :public,
        allegation_format:,
        allegation_details:,
        allegation_upload:,
        allegation_consideration_details:
      )
    end

    it "does not have any action links" do
      expect(row_links.compact).to be_empty
    end
  end
end
