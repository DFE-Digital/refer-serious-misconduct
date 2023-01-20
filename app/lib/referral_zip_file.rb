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

  private

  def zip_file
    temp_file = Tempfile.new("temp.zip")

    Zip::File.open(temp_file.path, create: true) do |zip_file|
      attachments.each do |attachment|
        next unless attachment.attached?

        file = ActiveStorage::Blob.service.path_for(attachment.key)
        zip_file.add(
          "#{attachment.name}/#{attachment.record.id}-#{attachment.filename}",
          File.join(file)
        )
      end
    end

    temp_file
  end

  def attachments
    files = [referral.duties_upload, referral.allegation_upload]

    files + referral.evidences.map(&:document)
  end
end
