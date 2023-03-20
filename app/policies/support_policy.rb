class SupportPolicy < ApplicationPolicy
  def index?
    return false if user.is_a?(AnonymousSupportUser)

    user.view_support?
  end

  def create?
    return false if user.is_a?(AnonymousSupportUser)

    user.view_support?
  end

  def edit?
    return false if user.is_a?(AnonymousSupportUser)

    user.view_support?
  end

  def update?
    return false if user.is_a?(AnonymousSupportUser)

    user.view_support?
  end

  def delete?
    return false if user.is_a?(AnonymousSupportUser)

    return user.view_support? unless record.is_a?(Staff)

    user.id != record.id
  end

  def destroy?
    return false if user.is_a?(AnonymousSupportUser)

    return user.view_support? unless record.is_a?(Staff)

    user.id != record.id
  end

  def authenticate?
    return false if user.is_a?(AnonymousSupportUser)

    user.view_support?
  end

  def activate?
    return false if user.is_a?(AnonymousSupportUser)

    user.view_support?
  end

  def deactivate?
    return false if user.is_a?(AnonymousSupportUser)

    user.view_support?
  end
end
