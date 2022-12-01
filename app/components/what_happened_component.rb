class WhatHappenedComponent < ViewComponent::Base
  include ActiveModel::Model

  attr_accessor :referral

  def allegation_confirm_form
    @allegation_confirm_form ||=
      Referrals::Allegation::ConfirmForm.new(referral:)
  end

  def rows
    [
      {
        actions: [
          {
            text: "Change",
            href: referrals_edit_allegation_details_path(referral),
            visually_hidden_text: "summary"
          }
        ],
        key: {
          text: "Summary"
        },
        value: {
          text: allegation_confirm_form.allegation_details
        }
      },
      {
        actions: [
          {
            text: "Change",
            href: referrals_edit_allegation_dbs_path(referral),
            visually_hidden_text: "DBS notified"
          }
        ],
        key: {
          text: "Have you told DBS?"
        },
        value: {
          text: referral.dbs_notified ? "Yes" : "No"
        }
      }
    ]
  end
end
