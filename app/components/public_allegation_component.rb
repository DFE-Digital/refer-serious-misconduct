class PublicAllegationComponent < ViewComponent::Base
  include ActiveModel::Model

  attr_accessor :referral

  def allegation_check_answers_form
    @allegation_check_answers_form ||=
      Referrals::Allegation::CheckAnswersForm.new(referral:)
  end

  def details_format
    case referral.allegation_format
    when "details"
      "Describe the allegation"
    when "upload"
      "File upload"
    else
      "Incomplete"
    end
  end

  def file_upload?
    referral.allegation_format == "upload"
  end

  def details_described?
    referral.allegation_format == "details"
  end

  def details_text
    return file_link if file_upload?
    return referral.allegation_details if details_described?

    "Incomplete"
  end

  def file_link
    upload = referral.allegation_upload
    govuk_link_to(
      upload.filename,
      rails_blob_path(upload, disposition: "attachment")
    )
  end

  def rows
    [
      {
        actions: [
          {
            text: "Change",
            href:
              edit_public_referral_allegation_details_path(
                referral,
                return_to: request.path
              ),
            visually_hidden_text:
              "how you want to give details about the allegation"
          }
        ],
        key: {
          text: "How do you want to give details about the allegation?"
        },
        value: {
          text: details_format
        }
      },
      {
        actions: [
          {
            text: "Change",
            href:
              edit_public_referral_allegation_details_path(
                referral,
                return_to: request.path
              ),
            visually_hidden_text: "description of the allegation"
          }
        ],
        key: {
          text: "Description of the allegation"
        },
        value: {
          text: details_text
        }
      },
      {
        actions: [
          {
            text: "Change",
            href:
              edit_public_referral_allegation_considerations_path(
                referral,
                return_to: request.path
              ),
            visually_hidden_text:
              "details about how this complaint has been considered"
          }
        ],
        key: {
          text: "Details about how this complaint has been considered"
        },
        value: {
          text: referral.allegation_consideration_details || "Incomplete"
        }
      }
    ]
  end
end
