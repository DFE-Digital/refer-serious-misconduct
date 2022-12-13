class WhatHappenedComponent < ViewComponent::Base
  include ActiveModel::Model

  attr_accessor :referral

  def allegation_check_answers_form
    @allegation_check_answers_form ||=
      Referrals::Allegation::CheckAnswersForm.new(referral:)
  end

  def rows
    [
      {
        actions: [
          {
            text: "Change",
            href:
              edit_referral_allegation_details_path(
                referral,
                return_to: request.url
              ),
            visually_hidden_text: "summary"
          }
        ],
        key: {
          text: "Summary"
        },
        value: {
          text: allegation_check_answers_form.allegation_details
        }
      },
      {
        actions: [
          {
            text: "Change",
            href:
              referrals_edit_allegation_dbs_path(
                referral,
                return_to: request.url
              ),
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
