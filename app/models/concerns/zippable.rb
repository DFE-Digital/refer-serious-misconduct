require "zip"

module Zippable
  extend ActiveSupport::Concern

  included do
    def zip_file_path
      @zip_file_path ||= zip_file.path
    end

    def zip_file_name
      "#{Time.zone.now.to_fs(:number)}-#{self.class.name.downcase}-#{id}.zip"
    end

    def has_attachments?
      has_own_attachments? || has_evidence_attachments?
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
      files = []

      self.class.zippable_attachments.each do |zippable_attachment|
        files << send(zippable_attachment)
      end

      files + evidences.map(&:document)
    end

    def has_own_attachments?
      self.class.zippable_attachments.any? do |attachment|
        send(attachment).attached?
      end
    end

    def has_evidence_attachments?
      evidences.any? { |evidence| evidence.document.attached? }
    end
  end

  class_methods do
    def zippable_attachments
      reflect_on_all_attachments.map(&:name)
    end
  end
end
