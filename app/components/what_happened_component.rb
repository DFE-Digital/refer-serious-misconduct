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
            href: [
              :edit,
              referral.routing_scope,
              referral,
              :allegation,
              :details,
              { return_to: }
            ],
            visually_hidden_text: "how I want to report the allegation"
          }
        ],
        key: {
          text: "Summary"
        },
        value: {
          text: allegation_details
        }
      },
      {
        actions: [
          {
            text: "Change",
            href: [
              :edit,
              referral.routing_scope,
              referral,
              :allegation,
              :dbs,
              { return_to: }
            ],
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

  def allegation_details
    if referral.allegation_upload.attached?
      [
        "File:",
        govuk_link_to(
          referral.allegation_upload.filename,
          rails_blob_path(referral.allegation_upload, disposition: "attachment")
        )
      ].join(" ").html_safe
    elsif referral.allegation_details.present?
      referral.allegation_details.truncate(150)
    else
      "Incomplete"
    end
  end

  def return_to
    polymorphic_path(
      [:edit, referral.routing_scope, referral, :allegation, :check_answers]
    )
  end
end
