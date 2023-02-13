class SupportPolicy < ApplicationPolicy
  def index?
    return user.view_support? if user.is_a?(Staff)

    super
  end

  def create?
    return user.view_support? if user.is_a?(Staff)

    super
  end

  def authenticate?
    return user.view_support? if user.is_a?(Staff)

    false
  end
end
