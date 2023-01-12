module RouteConstraints
  class PublicConstraint
    def matches?(request)
      id = request.params[:public_referral_id]
      Referral.member_of_public.exists?(id)
    end
  end
end
