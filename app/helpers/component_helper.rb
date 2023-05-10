module ComponentHelper
  extend ActiveSupport::Concern

  included { attr_accessor :referral, :user, :referral_form_invalid }

  def editable
    !referral.submitted?
  end

  def error
    referral_form_invalid && !section.complete?
  end
end
