module RouteConstraints
  class EmployerConstraint
    def matches?(request)
      id = request.params[:referral_id]
      referral = Referral.employer.find_by(id:)

      !(
        referral.blank? ||
          referral.submitted? && request.params[:action] == "update"
      )
    end
  end
end
