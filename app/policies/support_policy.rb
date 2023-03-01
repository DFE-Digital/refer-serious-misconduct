class SupportPolicy < ApplicationPolicy
  def index?
    return user.view_support? if user.is_a?(Staff)

    super
  end

  def create?
    return user.view_support? if user.is_a?(Staff)

    super
  end

  def edit?
    return user.view_support? if user.is_a?(Staff)

    super
  end

  def update?
    return user.view_support? if user.is_a?(Staff)

    super
  end

  def authenticate?
    return user.view_support? if user.is_a?(Staff)

    false
  end

  def activate?
    return user.view_support? if user.is_a?(Staff)

    false
  end

  def deactivate?
    return user.view_support? if user.is_a?(Staff)

    false
  end
end
