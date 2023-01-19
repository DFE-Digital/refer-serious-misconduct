class WhatHappenedComponent < ViewComponent::Base
  include ActiveModel::Model
  include ReferralHelper

  attr_accessor :referral

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

  def return_to
    polymorphic_path(
      [:edit, referral.routing_scope, referral, :allegation, :check_answers]
    )
  end
end
