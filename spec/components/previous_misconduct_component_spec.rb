require "rails_helper"

RSpec.describe PreviousMisconductComponent, type: :component do
  subject(:component) { described_class.new(referral:) }

  let(:referrer) { referral.referrer }
  let(:row_labels) { component.rows.map { |row| row.dig(:key, :text) } }
  let(:row_values) { component.rows.map { |row| row.dig(:value, :text) }.map(&:strip) }
  let(:row_values_sanitized) do
    row_values.map { |value| ActionView::Base.full_sanitizer.sanitize(value) }
  end
  let(:row_links) { component.rows.map { |row| row.dig(:actions, :href) } }

  before { render_inline(component) }

  context "without previous misconduct" do
    let(:referral) { create(:referral, :complete) }

    it "renders the labels" do
      expect(row_labels).to eq(["Has there been any previous misconduct?"])
    end

    it "renders the values" do
      expect(row_values).to eq(["Not answered"])
    end

    it "renders the change links" do
      expect(row_links).to eq(
        ["/referrals/#{referral.id}/previous-misconduct/reported/edit?return_to=%2F"]
      )
    end
  end

  context "with previous misconduct" do
    let(:referral) { create(:referral, :complete, :previous_misconduct_employer) }

    it "renders the labels" do
      expect(row_labels).to eq(
        [
          "Has there been any previous misconduct?",
          "How do you want to give details about previous allegations?",
          "Detailed account"
        ]
      )
    end

    it "renders the values" do
      expect(row_values_sanitized).to eq(
        ["Yes", "Describe the allegation", "They were rude to a child"]
      )
    end

    it "renders the change links" do
      expect(row_links).to eq(
        [
          "/referrals/#{referral.id}/previous-misconduct/reported/edit?return_to=%2F",
          "/referrals/#{referral.id}/previous-misconduct/detailed-account/edit?return_to=%2F",
          "/referrals/#{referral.id}/previous-misconduct/detailed-account/edit?return_to=%2F"
        ]
      )
    end

    context "with a file upload" do
      let(:referral) { create(:referral, :complete, :previous_misconduct_employer_upload) }

      it "renders the labels" do
        expect(row_labels).to eq(
          [
            "Has there been any previous misconduct?",
            "How do you want to give details about previous allegations?",
            "Detailed account"
          ]
        )
      end

      it "renders the values" do
        expect(row_values_sanitized).to eq(["Yes", "Upload file", "upload1.pdf"])
      end

      it "renders the change links" do
        expect(row_links).to eq(
          [
            "/referrals/#{referral.id}/previous-misconduct/reported/edit?return_to=%2F",
            "/referrals/#{referral.id}/previous-misconduct/detailed-account/edit?return_to=%2F",
            "/referrals/#{referral.id}/previous-misconduct/detailed-account/edit?return_to=%2F"
          ]
        )
      end
    end

    context "when referral is submitted" do
      let(:referral) { create(:referral, :submitted) }

      it "does not have any action links" do
        expect(row_links.compact).to be_empty
      end
    end
  end
end
