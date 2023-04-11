require "rails_helper"

RSpec.describe AboutYouComponent, type: :component do
  subject(:component) { described_class.new(referral:, user:) }

  let(:user) { referral.user }
  let(:referrer) { referral.referrer }
  let(:row_labels) { component.rows.map { |row| row.dig(:key, :text) } }
  let(:row_links) { component.rows.map { |row| row.dig(:actions, :href) } }

  before { render_inline(component) }

  context "with an employer referral" do
    let(:referral) { create(:referral, :complete) }

    it "renders rows in the right order" do
      expect(row_labels).to eq(
        ["Your name", "Your email address", "Your job title", "Your phone number"]
      )
    end

    it "renders the name row" do
      expect(page).to have_css("dd", text: referrer.name)
      expect(page).to have_link "Change",
                href: "/referrals/#{referral.id}/referrer/name/edit?return_to=%2F"
    end

    it "renders the email row" do
      expect(page).to have_css("dd", text: user.email)
    end

    it "renders the job title row" do
      expect(page).to have_css("dd", text: referrer.job_title)
      expect(page).to have_link "Change",
                href: "/referrals/#{referral.id}/referrer/job-title/edit?return_to=%2F"
    end

    it "renders the phone row" do
      expect(page).to have_css("dd", text: referrer.phone)
      expect(page).to have_link "Change",
                href: "/referrals/#{referral.id}/referrer/phone/edit?return_to=%2F"
    end
  end

  context "with a public referral" do
    let(:referral) { create(:referral, :public_complete) }

    it "renders rows in the right order" do
      expect(row_labels).to eq(["Your name", "Your email address", "Your phone number"])
    end

    it "doesn't render the job title row" do
      expect(page).not_to have_css("dd", text: referrer.job_title)
      expect(page).not_to have_link "Change",
                href: "/referrals/#{referral.id}/referrer/job-title/edit?return_to=%2F"
    end
  end

  context "when referral is submitted" do
    let(:referral) { create(:referral, :submitted) }

    it "does not have any action links" do
      expect(row_links.compact).to be_empty
    end
  end
end
