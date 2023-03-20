class AnonymousSupportUser
  def has_invitations_left?
    true
  end

  def devise_scope
    :staff
  end

  def view_support?
    false
  end

  def manage_referrals?
    false
  end
end
