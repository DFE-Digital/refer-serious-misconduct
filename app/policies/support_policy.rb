class SupportPolicy < ApplicationPolicy
  def index?
    user.view_support?
  end

  def create?
    user.view_support?
  end

  def edit?
    user.view_support?
  end

  def update?
    user.view_support?
  end

  def delete?
    user.view_support?
  end

  def destroy?
    user.view_support?
  end

  def authenticate?
    user.view_support?
  end

  def activate?
    user.view_support?
  end

  def deactivate?
    user.view_support?
  end

  def history?
    user.view_support?
  end
end
