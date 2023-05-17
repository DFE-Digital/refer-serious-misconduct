class ReferralFormBaseComponent < ViewComponent::Base
  include ActiveModel::Model
  include ApplicationHelper
  include AddressHelper
  include ReferralHelper

  attr_accessor :referral, :user, :referral_form_invalid

  delegate :referrer, :organisation, to: :referral

  def rows
    complete_rows
  end

  def complete_rows
    section.complete_rows(all_rows)
  end

  def all_rows
    raise NotImplementedError, "You must define all_rows in #{self.class}"
  end

  def editable
    !referral.submitted?
  end

  def error
    referral_form_invalid && !section.complete?
  end

  private

  def section
    raise NotImplementedError, "You must define section in #{self.class}"
  end
end
