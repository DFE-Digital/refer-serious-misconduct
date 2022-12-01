module ReferralHelper
  def evidence_categories_back_link(form)
    previous_evidence = form.previous_evidence
    if previous_evidence.present?
      referrals_edit_evidence_categories_path(form.referral, previous_evidence)
    else
      referrals_evidence_uploaded_path(form.referral)
    end
  end

  def evidence_confirm_back_link(referral)
    if referral.evidences.any?
      referrals_edit_evidence_categories_path(referral, referral.evidences.last)
    else
      referrals_edit_evidence_start_path(referral)
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
end
