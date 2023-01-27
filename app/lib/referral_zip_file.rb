require "zip"

class ReferralZipFile
  attr_accessor :referral

  def initialize(referral)
    @referral = referral
  end

  def path
    @path ||= zip_file.path
  end

  def name
    "#{Time.zone.now.to_fs(:number)}-referral-#{referral.id}.zip"
  end

  def has_attachments?
    attachments.any?(&:attached?)
  end

  private

  def zip_file
    temp_zip_file = Tempfile.new("temp.zip")
    temp_attachments = []

    Zip::File.open(temp_zip_file.path, create: true) do |zip|
      attachments.each do |attachment|
        next unless attachment.attached?

        blob = attachment.blob
        temp_attachment = Tempfile.new(blob.filename.sanitized)

        File.open(temp_attachment, "wb+") do |file|
          blob.download { |chunk| file.write(chunk) }
        end

        zip.add(
          "#{attachment.name}/#{attachment.record.id}-#{attachment.filename}",
          File.join(temp_attachment.path)
        )

        temp_attachments << temp_attachment
      end
    end

    temp_attachments.each do |file|
      file.close
      file.unlink
    end

    temp_zip_file
  end

  def attachments
    files = [referral.duties_upload, referral.allegation_upload]

    files + referral.evidences.map(&:document)
  end
end
