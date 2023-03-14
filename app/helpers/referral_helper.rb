module ReferralHelper
  include FileSizeHelper

  def duties_format(referral)
    case referral.duties_format
    when "details"
      if referral.duties_details.present?
        "Describe their main duties"
      else
        "Incomplete"
      end
    when "upload"
      referral.duties_upload.attached? ? "Upload file" : "Incomplete"
    else
      "Not answered"
    end
  end

  def duties_details(referral)
    case referral.duties_format
    when "details"
      if referral.duties_details.present?
        simple_format(referral.duties_details)
      else
        "Incomplete"
      end
    when "upload"
      if referral.duties_upload.attached?
        govuk_link_to(
          referral.duties_upload.filename,
          rails_blob_path(referral.duties_upload, disposition: "attachment")
        )
      else
        "Incomplete"
      end
    else
      "Not answered"
    end
  end

  def employment_status(referral)
    case referral.employment_status
    when "employed"
      "Yes"
    when "suspended"
      "They’re still employed but they’ve been suspended"
    when "left_role"
      "No"
    else
      "Not answered"
    end
  end

  def allegation_details_format(referral)
    case referral.allegation_format
    when "details"
      if referral.allegation_details.present?
        "Describe the allegation"
      else
        "Incomplete"
      end
    when "upload"
      referral.allegation_upload.attached? ? "Upload file" : "Incomplete"
    else
      "Not answered"
    end
  end

  def allegation_details(referral)
    case referral.allegation_format
    when "details"
      if referral.allegation_details.present?
        simple_format(referral.allegation_details)
      else
        "Incomplete"
      end
    when "upload"
      if referral.allegation_upload.attached?
        govuk_link_to(
          referral.allegation_upload.filename,
          rails_blob_path(referral.allegation_upload, disposition: "attachment")
        )
      else
        "Incomplete"
      end
    else
      "Not answered"
    end
  end

  def previous_allegation_details(referral)
    if referral.previous_misconduct_upload.attached?
      govuk_link_to(
        referral.previous_misconduct_upload.filename,
        rails_blob_path(
          referral.previous_misconduct_upload,
          disposition: "attachment"
        )
      )
    elsif referral.previous_misconduct_details.present?
      simple_format(referral.previous_misconduct_details)
    else
      "Incomplete"
    end
  end

  def nullable_boolean_to_s(
    value,
    yes = "Yes",
    noo = "No",
    not_answered = "Not answered"
  )
    value.nil? && not_answered || value && yes || noo
  end

  def nullable_value_to_s(value, not_answered = "Not answered")
    value.nil? && not_answered || value
  end

  def return_to_path
    if request.path.ends_with?("/check-answers")
      "#{request.path}/edit"
    else
      request.path
    end
  end
end
