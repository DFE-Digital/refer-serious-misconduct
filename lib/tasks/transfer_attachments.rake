desc "Transfers the ActiveStorage attachments from referrals to uploads"
task transfer_attachments: :environment do
  sections = %w[allegation duties previous_misconduct]

  sections.each do |section|
    attachments =
      ActiveStorage::Attachment.where(record_type: "Referral", name: "#{section}_upload")

    ActiveRecord::Base.transaction do
      attachments.each do |attachment|
        upload = attachment.record.uploads.new(section:)
        upload.save(validate: false)
        attachment.update(record: upload, record_type: "Upload", name: "file")
      end
    end
  end

  attachments = ActiveStorage::Attachment.where(record_type: "ReferralEvidence")

  ActiveRecord::Base.transaction do
    attachments.each do |attachment|
      upload = attachment.record.referral.uploads.new(section: "evidence")
      upload.save(validate: false)
      attachment.update(record: upload, record_type: "Upload", name: "file")
    end
  end
end
