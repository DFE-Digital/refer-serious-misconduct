class StaffPolicy < ApplicationPolicy
  def delete?
    user.id != record.id
  end

  def destroy?
    user.id != record.id
  end
end
