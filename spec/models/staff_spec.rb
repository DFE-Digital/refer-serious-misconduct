require "rails_helper"

RSpec.describe Staff, type: :model do
  describe "validations" do
    subject { staff.valid? }

    context "when the password is valid" do
      let(:staff) { build(:staff, password: "Password123!") }

      it { is_expected.to be_truthy }
    end

    context "when the password is invalid" do
      context "when the password is too short" do
        let(:staff) { build(:staff, password: "password") }

        it { is_expected.to be_falsey }
      end

      context "when the password does not contain an uppercase letter" do
        let(:staff) { build(:staff, password: "password123!") }

        it { is_expected.to be_falsey }
      end

      context "when the password does not contain a lowercase letter" do
        let(:staff) { build(:staff, password: "PASSWORD123!") }

        it { is_expected.to be_falsey }
      end

      context "when the password does not contain a digit" do
        let(:staff) { build(:staff, password: "Password!") }

        it { is_expected.to be_falsey }
      end

      context "when the password does not contain a special character" do
        let(:staff) { build(:staff, password: "Password123") }

        it { is_expected.to be_falsey }
      end
    end

    context "when the email address is already taken" do
      before { create(:staff) }

      let(:staff) { build(:staff) }

      it { is_expected.to be_falsey }
    end

    context "when the permissions are invalid" do
      let(:staff) { build(:staff, view_support: nil, manage_referrals: nil) }

      it { is_expected.to be_falsey }
    end
  end

  describe "#archive" do
    let(:staff) { create(:staff) }

    it "marks the user as deleted" do
      staff.archive

      expect(staff.deleted_at).to be_within(1).of(Time.zone.now)
    end
  end

  describe "#invitation_taken?" do
    subject { staff.invitation_taken? }

    context "when the staff member accepted their invitation" do
      let(:staff) { create(:staff, :confirmed, invitation_accepted_at: 1.day.ago) }

      it { is_expected.to be_truthy }
    end

    context "when the staff member accepted their invitation and was removed" do
      let(:staff) { create(:staff, :confirmed, :deleted, invitation_accepted_at: 1.day.ago) }

      it { is_expected.to be_falsey }
    end
  end

  describe ".invite!" do
    subject(:reinvited_staff) { described_class.invite!(new_invite_params) }

    # The invite form sends only the permissions that are ticked.
    let(:new_invite_params) { { email: "test@example.org", manage_referrals: "1" } }

    shared_examples "a returning staff member" do
      it "sends a new invitation and reactivates them" do
        expect { reinvited_staff }.to have_enqueued_mail(DeviseMailer, :invitation_instructions)

        aggregate_failures do
          expect(reinvited_staff.errors).to be_empty
          expect(reinvited_staff.deleted_at).to be_nil
          expect(reinvited_staff).not_to be_invitation_accepted
          expect(described_class.active).to include(reinvited_staff)
        end
      end

      it "replaces their old permissions with the new invitation's" do
        aggregate_failures do
          expect(reinvited_staff.view_support).to be(false)
          expect(reinvited_staff.manage_referrals).to be(true)
          expect(reinvited_staff.developer).to be(false)
          expect(reinvited_staff.feedback_notification).to be(false)
        end
      end

      it "lets them sign in after accepting" do
        described_class.accept_invitation!(
          invitation_token: reinvited_staff.raw_invitation_token,
          password: "Password123!",
          password_confirmation: "Password123!"
        )

        expect(reinvited_staff.reload).to be_active_for_authentication
      end
    end

    context "when a removed staff member had accepted their invitation" do
      before do
        create(:staff, :confirmed, :deleted, :developer, :feedback_notification, invitation_accepted_at: 1.day.ago)
      end

      it_behaves_like "a returning staff member"
    end

    context "when a removed staff member never accepted their invitation" do
      before do
        staff = described_class.invite!(email: "test@example.org", view_support: "1", feedback_notification: "1")
        staff.archive
        staff.save!
      end

      it_behaves_like "a returning staff member"
    end
  end
end
