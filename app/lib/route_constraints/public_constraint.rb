module RouteConstraints
  class PublicConstraint
    def matches?(request)
      id = request.params[:public_referral_id]
      referral = Referral.member_of_public.find_by(id:)

      !(
        referral.blank? ||
          referral.submitted? && request.params[:action] == "update"
      )
    end
  end
end
