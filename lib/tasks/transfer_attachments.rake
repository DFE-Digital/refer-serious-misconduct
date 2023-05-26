desc "Transfers the ActiveStorage attachments from referrals to uploads"
task transfer_attachments: :environment do
  attachments = ActiveStorage::Attachment.where(record_type: "Referral", name: "allegation_upload")

  ActiveRecord::Base.transaction do
    attachments.each do |attachment|
      upload = attachment.record.uploads.create!(section: "allegation")
      attachment.update(record: upload, record_type: "Upload", name: "attachment")
    end
  end
end
