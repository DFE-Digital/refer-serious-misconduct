# frozen_string_literal: true

require "rails_helper"

RSpec.describe NavigationComponent, type: :component do
  describe "user-facing nav" do
    let(:current_staff) { nil }
    let(:current_user) { build(:user) }
    let(:render!) do
      render_inline(described_class.new(current_user:, current_staff:))
    end

    before { FeatureFlags::FeatureFlag.activate(:referral_form) }

    it "does not contain support interface links" do
      render!
      expect(page).not_to have_content "Staff"
      expect(page).not_to have_content "Features"
    end

    it "contains a sign out link" do
      render!
      expect(page).to have_link("Sign out", href: routing.users_sign_out_path)
      expect(page).not_to have_content "Sign in"
    end

    context "when the user has no referrals" do
      it "the service link goes to the root path" do
        render!

        expect(page).to have_link(
          I18n.t("service.name"),
          href: routing.root_path
        )
      end
    end

    context "when the user has referrals" do
      let(:referral) { create(:referral) }
      let(:current_user) { referral.user }

      it "the service link goes to the referral" do
        render!

        expect(page).to have_link(
          I18n.t("service.name"),
          href: routing.edit_referral_path(referral)
        )
      end
    end

    context "when there is no current_user" do
      let(:current_user) { nil }

      it "contains a sign in link" do
        render!

        expect(page).to have_link(
          "Sign in",
          href: routing.new_user_session_path
        )
        expect(page).not_to have_content "Sign out"
      end
    end
  end
end
