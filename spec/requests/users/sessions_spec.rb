require "rails_helper"

RSpec.describe "User sign in" do
  before { FeatureFlags::FeatureFlag.activate(:service_open) }

  describe "POST /users/session" do
    subject(:sign_in) { post "/users/session", params: { user: { email: } } }

    context "when a user exists with the email" do
      let!(:user) { create(:user, email: "returning@example.com") }

      context "and it is typed exactly as stored" do
        let(:email) { "returning@example.com" }

        it "sends a code to the existing user" do
          expect { sign_in }.not_to change(User, :count)

          expect(response).to redirect_to(new_user_otp_path(uuid: user.uuid, new_referral: false))
        end
      end

      context "and it differs in case and surrounding whitespace" do
        let(:email) { "  Returning@Example.com  " }

        it "sends a code to the existing user" do
          expect { sign_in }.not_to change(User, :count)

          expect(response).to redirect_to(new_user_otp_path(uuid: user.uuid, new_referral: false))
        end
      end
    end

    context "when no user exists with the email" do
      context "and it is typed in lowercase" do
        let(:email) { "new@example.com" }

        it "creates a user and sends them a code" do
          expect { sign_in }.to change(User, :count).by(1)

          new_user = User.find_by!(email: "new@example.com")
          expect(response).to redirect_to(
            new_user_otp_path(uuid: new_user.uuid, new_referral: false)
          )
        end
      end

      context "and it has mixed case and surrounding whitespace" do
        let(:email) { "  New@Example.com  " }

        it "creates a user with the normalised email and sends them a code" do
          expect { sign_in }.to change(User, :count).by(1)

          new_user = User.find_by!(email: "new@example.com")
          expect(response).to redirect_to(
            new_user_otp_path(uuid: new_user.uuid, new_referral: false)
          )
        end
      end
    end

    context "when the email is blank" do
      let!(:user) { create(:user) }
      let(:email) { " " }

      it "asks for an email instead of sending a code" do
        expect { sign_in }.not_to have_enqueued_mail(UserMailer, :otp)

        expect(response.body).to include("Enter your email")
        expect(user.reload.secret_key).to be_nil
      end
    end

    context "when the email is missing" do
      let!(:user) { create(:user) }

      it "asks for an email instead of sending a code" do
        expect {
          post "/users/session", params: { user: { unknown: "x" } }
        }.not_to have_enqueued_mail(UserMailer, :otp)

        expect(response.body).to include("Enter your email")
        expect(user.reload.secret_key).to be_nil
      end
    end
  end
end
