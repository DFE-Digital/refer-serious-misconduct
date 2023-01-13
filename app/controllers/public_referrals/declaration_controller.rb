module PublicReferrals
  class DeclarationController < Referrals::DeclarationController
    private

    def update_path
      public_referral_declaration_path(current_referral)
    end

    def back_link
      public_referral_review_path(current_referral)
    end

    def next_path
      public_referral_confirmation_path(current_referral)
    end
  end
end
