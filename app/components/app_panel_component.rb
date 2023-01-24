class AppPanelComponent < ViewComponent::Base
  include ActiveModel::Model

  attr_accessor :referral, :rows, :title

  def dom_id
    title.parameterize(separator: "_")
  end
end
