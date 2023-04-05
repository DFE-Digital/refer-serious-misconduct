require "rails_helper"

RSpec.describe WhatHappenedComponent, type: :component do
  subject(:component) { described_class.new(referral:) }

  let(:referral) { create(:referral, :employer_complete) }

  let(:row_labels) { component.rows.map { |row| row.dig(:key, :text) } }
  let(:row_values) { component.rows.map { |row| row.dig(:value, :text) }.map(&:strip) }
  let(:row_values_sanitized) do
    row_values.map { |value| ActionView::Base.full_sanitizer.sanitize(value) }
  end
  let(:row_links) { component.rows.map { |row| row.dig(:actions, :href) } }

  before { render_inline(component) }

  it "renders the correct questions" do
    expect(row_labels).to eq(
      [
        "How do you want to give details about the allegation?",
        "Description of the allegation",
        "Have you told DBS?"
      ]
    )
  end

  it "renders the correct answers" do
    expect(row_values_sanitized).to eq(
      ["Describe the allegation", "They were rude to a child", "Yes"]
    )
  end

  it "renders the correct change links" do
    expect(row_links).to eq(
      [
        "/referrals/#{referral.id}/allegation/details/edit?return_to=%2F",
        "/referrals/#{referral.id}/allegation/details/edit?return_to=%2F",
        "/referrals/#{referral.id}/allegation/dbs/edit?return_to=%2F"
      ]
    )
  end
end
