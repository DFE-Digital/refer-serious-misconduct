module ComponentHelper
  extend ActiveSupport::Concern

  included { attr_accessor :referral, :user }

  def remove_actions(items)
    items.map { |item| item.tap { |i| i.delete(:actions) } }
  end

  def editable
    !referral.submitted?
  end
end
