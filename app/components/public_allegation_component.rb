class PublicAllegationComponent < ViewComponent::Base
  include ActiveModel::Model
  include ComponentHelper
  include ReferralHelper

  attr_accessor :referral

  def allegation_check_answers_form
    @allegation_check_answers_form ||=
      Referrals::Allegation::CheckAnswersForm.new(referral:)
  end

  def file_upload?
    referral.allegation_format == "upload"
  end

  def details_described?
    referral.allegation_format == "details"
  end

  def file_link
    upload = referral.allegation_upload
    govuk_link_to(
      upload.filename,
      rails_blob_path(upload, disposition: "attachment")
    )
  end

  def rows
    items = [
      {
        actions: [
          {
            text: "Change",
            href:
              edit_public_referral_allegation_details_path(
                referral,
                return_to: return_to_path
              ),
            visually_hidden_text:
              "how you want to give details about the allegation"
          }
        ],
        key: {
          text: "How do you want to give details about the allegation?"
        },
        value: {
          text: allegation_details_format(referral)
        }
      },
      {
        actions: [
          {
            text: "Change",
            href:
              edit_public_referral_allegation_details_path(
                referral,
                return_to: return_to_path
              ),
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
            href:
              edit_public_referral_allegation_considerations_path(
                referral,
                return_to: return_to_path
              ),
            visually_hidden_text:
              "details about how this complaint has been considered"
          }
        ],
        key: {
          text: "Details about how this complaint has been considered"
        },
        value: {
          text:
            simple_format(
              nullable_value_to_s(
                referral.allegation_consideration_details.presence
              )
            )
        }
      }
    ]

    referral.submitted? ? remove_actions(items) : items
  end
end
