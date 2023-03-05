require "rails_helper"

RSpec.describe StartPath do
  include Rails.application.routes.url_helpers

  describe ".for" do
    subject { described_class.for(user:) }

    context "when the referral form is active" do
      before { FeatureFlags::FeatureFlag.activate(:referral_form) }

      context "when user is nil" do
        let(:user) { nil }

        it { is_expected.to eq(users_registrations_exists_path) }
      end

      context "when user is present" do
        let(:user) { create(:user) }

        it { is_expected.to eq(referral_type_path) }

        context "and the user has submitted a referral" do
          before { user.referrals << create(:referral, :submitted) }

          it { is_expected.to eq(users_referrals_path) }
        end

        context "and the user has public referral in progress" do
          let(:public_referral) { create(:referral, :public) }

          before { user.referrals << public_referral }

          it { is_expected.to eq(edit_public_referral_path(public_referral)) }
        end

        context "and the user has employer referral in progress" do
          let(:employer_referral) { create(:referral, :employer) }

          before { user.referrals << employer_referral }

          it { is_expected.to eq(edit_referral_path(employer_referral)) }
        end
      end
    end

    context "when the referral form is inactive" do
      before { FeatureFlags::FeatureFlag.deactivate(:referral_form) }

      context "when user is nil" do
        let(:user) { nil }

        it { is_expected.to eq(referral_type_path) }
      end

      context "when user is present" do
        let(:user) { build(:user) }

        it { is_expected.to eq(referral_type_path) }
      end
    end
  end
end
