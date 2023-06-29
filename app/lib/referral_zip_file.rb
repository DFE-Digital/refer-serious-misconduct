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
    referral.uploads.any? || referral.pdf.present?
  end

  private

  def zip_file
    temp_zip_file = Tempfile.new("temp.zip")
    temp_attachments = []

    Zip::File.open(temp_zip_file.path, create: true) do |zip|
      referral.uploads.each do |upload|
        zip_file_path = "#{upload.section}/#{filename_for(upload:)}"
        file = file_for(upload:)
        zip.add(zip_file_path, File.join(file.path))

        temp_attachments << file
      end

      if referral.pdf.present?
        file = pdf_from_referral
        zip.add("#{referral.id}-referral.pdf", File.join(file.path))

        temp_attachments << file
      end
    end

    temp_attachments.each do |file|
      file.close
      file.unlink
    end

    temp_zip_file
  end

  def filename_for(upload:)
    base_filename = "#{referral.id}-#{upload.filename}"
    return "#{base_filename}-file-removed-due-to-suspected-virus.txt" if upload.scan_result_suspect?
    return "#{base_filename}-file-being-checked-for-viruses.txt" if upload.scan_result_pending?

    base_filename
  end

  def file_for(upload:)
    temp_file_for(filename: filename_for(upload:)) do |file|
      if upload.scan_result_clean? && upload.file.attached?
        upload.file.blob.download { |chunk| file.write(chunk) }
      else
        file.write("file unavailable")
      end
    end
  end

  def pdf_from_referral
    temp_file_for(filename: "referral.pdf") do |file|
      referral.pdf.blob.download { |chunk| file.write(chunk) }
    end
  end

  def temp_file_for(filename:, &block)
    Tempfile.new(filename).tap { |temp_file| File.open(temp_file, "wb+", &block) }
  end
end
