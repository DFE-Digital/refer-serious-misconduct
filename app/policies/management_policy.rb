class ManagementPolicy < ApplicationPolicy
  def index?
    user.manage_referrals?
  end

  def show?
    user.manage_referrals?
  end
end
