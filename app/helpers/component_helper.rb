module ComponentHelper
  extend ActiveSupport::Concern

  included { attr_accessor :referral, :user, :referral_form_invalid }

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
end
