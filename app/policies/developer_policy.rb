class DeveloperPolicy < ApplicationPolicy
  def index?
    user.developer?
  end

  def deactivate?
    user.developer?
  end

  def activate?
    user.developer?
  end
end
