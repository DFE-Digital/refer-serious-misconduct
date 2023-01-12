module RouteConstraints
  class EmployerConstraint
    def matches?(request)
      id = request.params[:referral_id]
      Referral.employer.exists?(id)
    end
  end
end
