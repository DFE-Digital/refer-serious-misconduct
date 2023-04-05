class WhatHappenedComponent < ViewComponent::Base
  include ActiveModel::Model
  include ReferralHelper
  include ComponentHelper

  attr_accessor :referral

  def rows
    summary_rows [
                   details_about_allegation_format_row,
                   details_about_allegation_row,
                   dbs_notified_row
                 ].compact
  end

  private

  def details_about_allegation_format_row
    {
      label: "How do you want to give details about the allegation?",
      visually_hidden_text: "how you want to give details about the allegation",
      value: allegation_details_format(referral),
      path: :allegation_details
    }
  end

  def details_about_allegation_row
    {
      label: "Description of the allegation",
      value: allegation_details(referral),
      path: :allegation_details
    }
  end

  def dbs_notified_row
    {
      label: "Have you told DBS?",
      visually_hidden_text: "if you have told DBS",
      value: referral.dbs_notified,
      path: :allegation_dbs
    }
  end
end
