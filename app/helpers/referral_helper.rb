module ReferralHelper
  def evidence_categories_back_link(form)
    back_link = session.delete(:evidence_back_link)
    return back_link if back_link.present?

    referral_evidence_uploaded_path(form.referral)
  end

  def evidence_check_answers_link(referral)
    if referral.evidences.any?
      edit_referral_evidence_categories_path(referral, referral.evidences.last)
    else
      edit_referral_evidence_start_path(referral)
    end
  end

  def duties_details(referral)
    if referral.duties_upload.attached?
      "File: #{referral.duties_upload.filename}"
    elsif referral.duties_details.present?
      referral.duties_details.truncate(150, " ")
    else
      "Incomplete"
    end
  end

  def subsection_path(referral:, subsection:, action: nil, return_to: nil)
    referrer_scope = referral.from_employer? ? "referral" : "public_referral"
    path_name = [action, referrer_scope, subsection, "path"].compact_blank.join(
      "_"
    )

    args = [referral]
    args << { return_to: } if return_to

    send(path_name, *args)
  end
end
