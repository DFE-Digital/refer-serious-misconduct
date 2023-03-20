class ManagementPolicy < ApplicationPolicy
  def index?
    return false if user.is_a?(AnonymousSupportUser)

    user.manage_referrals?
  end

  def show?
    return false if user.is_a?(AnonymousSupportUser)

    user.manage_referrals?
  end
end
