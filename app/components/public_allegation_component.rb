class PublicAllegationComponent < ViewComponent::Base
  include ActiveModel::Model
  include ReferralHelper
  include ComponentHelper

  attr_accessor :referral

  def rows
    items =
      summary_rows [
                     allegation_details_format_row,
                     allegation_details_description_row,
                     allegation_details_considerations_row
                   ].compact

    referral.submitted? ? remove_actions(items) : items
  end

  def allegation_details_format_row
    {
      label: "How do you want to give details about the allegation?",
      visually_hidden_text: "how you want to give details about the allegation",
      value: allegation_details_format(referral),
      path: :allegation_details
    }
  end

  def allegation_details_description_row
    {
      label: "Description of the allegation",
      value: allegation_details(referral),
      path: :allegation_details
    }
  end

  def allegation_details_considerations_row
    {
      label: "Details about how this complaint has been considered",
      value: simple_format(nullable_value_to_s(referral.allegation_consideration_details.presence)),
      path: :allegation_considerations
    }
  end
end
