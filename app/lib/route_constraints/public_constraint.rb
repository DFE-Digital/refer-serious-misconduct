module RouteConstraints
  class PublicConstraint
    def matches?(request)
      id = request.params[:public_referral_id]
      referral = Referral.member_of_public.where(id:).first

      referral.present?
    end
  end
end
