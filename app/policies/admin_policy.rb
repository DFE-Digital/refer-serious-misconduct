class AdminPolicy < ApplicationPolicy
  def index?
    user.view_support? || user.manage_referrals?
  end
end
