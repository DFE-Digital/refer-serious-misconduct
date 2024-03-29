require "rails_helper"

RSpec.describe Referrals::TeacherPersonalDetailsComponent, type: :component do
  subject(:component) { described_class.new(referral:) }

  let(:referral) { create(:referral, :complete, :employer, :personal_details_employer) }

  let(:row_labels) { component.rows.map { |row| row.dig(:key, :text) } }
  let(:row_values) { component.rows.map { |row| row.dig(:value, :text) }.map(&:strip) }
  let(:row_values_sanitized) do
    row_values.map { |value| ActionView::Base.full_sanitizer.sanitize(value) }
  end
  let(:row_links) { component.rows.map { |row| row.dig(:actions, :href) } }

  before { render_inline(component) }

  it "renders the correct labels in order" do
    expect(row_labels).to eq(
      [
        "Their name",
        "Do you know them by any other name?",
        "Do you know their date of birth?",
        "Date of birth",
        "Do you know their National Insurance number?",
        "National Insurance number",
        "Do you know their teacher reference number (TRN)?",
        "TRN",
        "Do they have qualified teacher status (QTS)?"
      ]
    )
  end

  it "renders the name row" do
    expect(row_labels[0]).to eq("Their name")
    expect(row_values_sanitized[0]).to eq("#{referral.first_name} #{referral.last_name}")
    expect(row_links[0]).to eq("/referrals/#{referral.id}/personal-details/name/edit?return_to=%2F")
  end

  context "when not known by other name" do
    let(:referral) do
      create(:referral, :employer, :personal_details_employer, name_has_changed: "no")
    end

    it "renders the known name row" do
      expect(row_labels[1]).to eq("Do you know them by any other name?")
      expect(row_values_sanitized[1]).to eq("No")
      expect(row_links[1]).to eq(
        "/referrals/#{referral.id}/personal-details/name/edit?return_to=%2F"
      )
    end

    it "does not render the other name row" do
      expect(row_labels[2]).not_to eq("Other name")
    end
  end

  context "when known by other name" do
    let(:referral) do
      create(
        :referral,
        :employer,
        :personal_details_employer,
        name_has_changed: "yes",
        previous_name: "T"
      )
    end

    it "renders the known name row" do
      expect(row_labels[1]).to eq("Do you know them by any other name?")
      expect(row_values_sanitized[1]).to eq("Yes")
      expect(row_links[1]).to eq(
        "/referrals/#{referral.id}/personal-details/name/edit?return_to=%2F"
      )
    end

    it "renders the other name row" do
      expect(row_labels[2]).to eq("Other name")
      expect(row_values_sanitized[2]).to eq("T")
      expect(row_links[2]).to eq(
        "/referrals/#{referral.id}/personal-details/name/edit?return_to=%2F"
      )
    end
  end

  context "when date of birth is known" do
    let(:referral) do
      create(
        :referral,
        :employer,
        :personal_details_employer,
        age_known: true,
        date_of_birth: Date.new(1990, 1, 1)
      )
    end

    it "renders the date of birth known row" do
      expect(row_labels[2]).to eq("Do you know their date of birth?")
      expect(row_values_sanitized[2]).to eq("Yes")
      expect(row_links[2]).to eq(
        "/referrals/#{referral.id}/personal-details/age/edit?return_to=%2F"
      )
    end

    it "renders the date of birth row" do
      expect(row_labels[3]).to eq("Date of birth")
      expect(row_values_sanitized[3]).to eq(referral.date_of_birth&.to_fs(:long_ordinal_uk))
      expect(row_links[3]).to eq(
        "/referrals/#{referral.id}/personal-details/age/edit?return_to=%2F"
      )
    end
  end

  context "when date of birth is not known" do
    let(:referral) { create(:referral, :employer, :personal_details_employer, age_known: false) }

    it "renders the date of birth known row" do
      expect(row_labels[2]).to eq("Do you know their date of birth?")
      expect(row_values_sanitized[2]).to eq("No")
      expect(row_links[2]).to eq(
        "/referrals/#{referral.id}/personal-details/age/edit?return_to=%2F"
      )
    end

    it "does not render the date of birth row" do
      expect(row_labels[3]).not_to eq("Date of birth")
    end
  end

  context "when national insurance number is known" do
    let(:referral) { create(:referral, :employer, :personal_details_employer) }

    it "renders the national insurance number known row" do
      expect(row_labels[4]).to eq("Do you know their National Insurance number?")
      expect(row_values_sanitized[4]).to eq("Yes")
      expect(row_links[4]).to eq(
        "/referrals/#{referral.id}/personal-details/ni_number/edit?return_to=%2F"
      )
    end

    it "renders the national insurance number row" do
      expect(row_labels[5]).to eq("National Insurance number")
      expect(row_values_sanitized[5]).to eq(referral.ni_number)
      expect(row_links[5]).to eq(
        "/referrals/#{referral.id}/personal-details/ni_number/edit?return_to=%2F"
      )
    end
  end

  context "when national insurance number is not known" do
    let(:referral) do
      create(:referral, :employer, :personal_details_employer, ni_number_known: false)
    end

    it "renders the national insurance number known row" do
      expect(row_labels[4]).to eq("Do you know their National Insurance number?")
      expect(row_values_sanitized[4]).to eq("No")
      expect(row_links[4]).to eq(
        "/referrals/#{referral.id}/personal-details/ni_number/edit?return_to=%2F"
      )
    end

    it "does not render the national insurance number row" do
      expect(row_labels[4]).not_to eq("National Insurance number")
    end
  end

  context "when trn is known" do
    let(:referral) do
      create(:referral, :employer, :personal_details_employer, trn_known: true, trn: "4567814")
    end

    it "renders the trn known row" do
      expect(row_labels[6]).to eq("Do you know their teacher reference number (TRN)?")
      expect(row_values_sanitized[6]).to eq("Yes")
      expect(row_links[6]).to eq(
        "/referrals/#{referral.id}/personal-details/trn/edit?return_to=%2F"
      )
    end

    it "renders the trn row" do
      expect(row_labels[7]).to eq("TRN")
      expect(row_values_sanitized[7]).to eq(referral.trn)
      expect(row_links[7]).to eq(
        "/referrals/#{referral.id}/personal-details/trn/edit?return_to=%2F"
      )
    end
  end

  context "when trn is not known" do
    let(:referral) { create(:referral, :employer, :personal_details_employer, trn_known: false) }

    it "renders the trn known row" do
      expect(row_labels[6]).to eq("Do you know their teacher reference number (TRN)?")
      expect(row_values_sanitized[6]).to eq("No")
      expect(row_links[6]).to eq(
        "/referrals/#{referral.id}/personal-details/trn/edit?return_to=%2F"
      )
    end

    it "does not render the trn row" do
      expect(row_labels[7]).not_to eq("TRN")
    end
  end

  context "when qts is known" do
    it "renders the qts row" do
      expect(row_labels[8]).to eq("Do they have qualified teacher status (QTS)?")
      expect(row_values_sanitized[8]).to eq("Yes")
      expect(row_links[8]).to eq(
        "/referrals/#{referral.id}/personal-details/qts/edit?return_to=%2F"
      )
    end
  end

  context "when the referral is a public one" do
    let(:referral) { create(:referral, :public, :personal_details_public) }

    it "renders a limited number of questions" do
      expect(row_labels).to eq(["Their name", "Do you know them by any other name?"])
    end
  end
end
