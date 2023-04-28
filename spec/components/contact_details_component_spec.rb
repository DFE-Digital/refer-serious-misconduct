require "rails_helper"

RSpec.describe ContactDetailsComponent, type: :component do
  subject(:component) { described_class.new(referral:) }

  let(:referral) { create(:referral, :contact_details_employer) }
  let(:row_labels) { component.rows.map { |row| row.dig(:key, :text) } }
  let(:row_links) { component.rows.map { |row| row.dig(:actions, :href) } }

  before { render_inline(component) }

  it "renders rows in the right order" do
    expect(row_labels).to eq(
      [
        "Do you know their email address?",
        "Email address",
        "Do you know their phone number?",
        "Phone number",
        "Do you know their home address?",
        "Home address"
      ]
    )
  end

  context "when the email is known" do
    it "renders the email known row" do
      expect(page).to have_css("dt", text: "Do you know their email address?")
      expect(page).to have_css("dd", text: "Yes")
      expect(page).to have_link "Change",
                href: "/referrals/#{referral.id}/contact-details/email/edit?return_to=%2F"
    end

    it "renders the referral email row" do
      expect(page).to have_css("dt", text: "Email address")
      expect(page).to have_css("dd", text: referral.email_address)
    end
  end

  context "when the email is not known" do
    let(:referral) do
      create(:referral, :contact_details_employer, email_known: false, email_address: nil)
    end

    it "renders the email not known row" do
      expect(page).to have_css("dt", text: "Do you know their email address?")
      expect(page).to have_css("dd", text: "No")
      expect(page).to have_link "Change",
                href: "/referrals/#{referral.id}/contact-details/email/edit?return_to=%2F"
    end

    it "does not render the referral email row" do
      expect(page).not_to have_css("dt", text: "Email address")
    end
  end

  context "when the phone number is known" do
    it "renders the phone number known row" do
      expect(page).to have_css("dt", text: "Do you know their phone number?")
      expect(page).to have_css("dd", text: "Yes")
      expect(page).to have_link "Change",
                href: "/referrals/#{referral.id}/contact-details/telephone/edit?return_to=%2F"
    end

    it "renders the referral phone number row" do
      expect(page).to have_css("dt", text: "Phone number")
      expect(page).to have_css("dd", text: referral.phone_number)
    end
  end

  context "when the phone number is not known" do
    let(:referral) do
      create(:referral, :contact_details_employer, phone_known: false, phone_number: nil)
    end

    it "renders the phone number not known row" do
      expect(page).to have_css("dt", text: "Do you know their phone number?")
      expect(page).to have_css("dd", text: "No")
      expect(page).to have_link "Change",
                href: "/referrals/#{referral.id}/contact-details/telephone/edit?return_to=%2F"
    end

    it "does not render the referral phone number row" do
      expect(page).not_to have_css("dt", text: "Phone number")
    end
  end

  context "when the home address is known" do
    it "renders the home address known row" do
      expect(page).to have_css("dt", text: "Do you know their home address?")
      expect(page).to have_css("dd", text: "Yes")
      expect(page).to have_link "Change",
                href: "/referrals/#{referral.id}/contact-details/address_known/edit?return_to=%2F"
    end

    it "renders the home address row" do
      expect(page).to have_css("dt", text: "Home address")
      expect(page).to have_css("dd", text: referral.address_line_1)
      expect(page).to have_css("dd", text: referral.address_line_2)
      expect(page).to have_css("dd", text: referral.town_or_city)
      expect(page).to have_css("dd", text: referral.postcode)
      expect(page).to have_css("dd", text: referral.country)
    end
  end

  context "when the home address is not known" do
    let(:referral) { create(:referral, :contact_details_employer, address_known: false) }

    it "renders the home address not known row" do
      expect(page).to have_css("dt", text: "Do you know their home address?")
      expect(page).to have_css("dd", text: "No")
    end

    it "does not render the home address row" do
      expect(page).not_to have_css("dt", text: "Home address")
    end
  end
end
