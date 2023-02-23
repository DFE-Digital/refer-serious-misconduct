class WhatHappenedComponent < ViewComponent::Base
  include ActiveModel::Model
  include ReferralHelper
  include ComponentHelper

  attr_accessor :referral

  def rows
    items = [
      {
        actions: [
          {
            text: "Change",
            href: [
              :edit,
              referral.routing_scope,
              referral,
              :allegation,
              :details
            ],
            visually_hidden_text:
              "how you want to give details about the allegation"
          }
        ],
        key: {
          text: "How do you want to give details about the allegation?"
        },
        value: {
          text: allegation_details_type
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
              :details,
              { return_to: }
            ],
            visually_hidden_text: "description of the allegation"
          }
        ],
        key: {
          text: "Description of the allegation"
        },
        value: {
          text: allegation_details(referral)
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
            visually_hidden_text: "if you have told DBS"
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

    referral.submitted? ? remove_actions(items) : items
  end

  def return_to
    polymorphic_path(
      [:edit, referral.routing_scope, referral, :allegation, :check_answers]
    )
  end

  private

  def allegation_details_type
    return "Upload file" if referral.allegation_upload.attached?
    return "Describe the allegation" if referral.allegation_details.present?

    "Incomplete"
  end
end
