module ReferralHelper
  def duties_format(referral)
    return "Describe their main duties" if referral.duties_format == "details"

    "Upload file"
  end

  def duties_details(referral)
    if referral.duties_upload.attached?
      govuk_link_to(
        referral.duties_upload.filename,
        rails_blob_path(referral.duties_upload, disposition: "attachment")
      )
    elsif referral.duties_details.present?
      referral.duties_details.truncate(150)
    else
      "Incomplete"
    end
  end

  def employment_status(referral)
    case referral.employment_status
    when "employed"
      "Yes"
    when "suspended"
      "They’re still employed but they’ve been suspended"
    when "left_role"
      "No, they have left the organisation"
    else
      "Incomplete"
    end
  end
end
