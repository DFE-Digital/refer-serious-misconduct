desc "Transfers the ActiveStorage attachments from referrals to uploads"
task transfer_attachments: :environment do
  ActiveRecord::Base.transaction do
    sections = %w[allegation duties previous_misconduct]

    sections.each do |section|
      attachments =
        ActiveStorage::Attachment.where(record_type: "Referral", name: "#{section}_upload")

      attachments.each do |attachment|
        upload = attachment.record.uploads.new(section:, filename: attachment.filename.to_s)
        upload.save(validate: false)
        attachment.update(record: upload, record_type: "Upload", name: "file")
      end

      puts "Transferred #{attachments.size} #{section} attachments"
    end

    evidence_attachments = ActiveStorage::Attachment.where(record_type: "ReferralEvidence")

    evidence_attachments.each do |attachment|
      upload =
        attachment.record.referral.uploads.new(
          section: "evidence",
          filename: attachment.filename.to_s
        )
      upload.save(validate: false)
      attachment.update(record: upload, record_type: "Upload", name: "file")
    end

    puts "Transferred #{evidence_attachments.size} evidence attachments"
  end
end
