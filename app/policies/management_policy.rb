class ManagementPolicy < ApplicationPolicy
  def index?
    return user.manage_referrals? if user.is_a?(Staff)

    super
  end

  def show?
    return user.manage_referrals? if user.is_a?(Staff)

    super
  end
end
