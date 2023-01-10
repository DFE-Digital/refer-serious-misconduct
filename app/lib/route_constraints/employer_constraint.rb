module RouteConstraints
  class EmployerConstraint
    def matches?(request)
      id = request.params[:referral_id]
      referral = Referral.employer.where(id:).first

      referral.present?
    end
  end
end
