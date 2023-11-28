class FileUploadValidator < ActiveModel::EachValidator
  include FileSizeHelper

  MAX_FILE_SIZE = 100.megabytes
  MAX_FILES = 20

  CONTENT_TYPES = {
    ".apng" => "image/apng",
    ".avif" => "image/avif",
    ".doc" => "application/msword",
    ".docx" => "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
    ".eml" => "message/rfc822",
    ".gif" => "image/gif",
    ".heic" => "image/heic",
    ".heif" => "image/heif",
    ".jpg" => "image/jpeg",
    ".jpeg" => "image/jpeg",
    ".m4a" => "audio/mp4",
    ".mov" => "video/quicktime",
    ".mp3" => "audio/mpeg",
    ".mp4" => "video/mp4",
    ".msg" => "application/x-ole-storage",
    ".pdf" => "application/pdf",
    ".png" => "image/png",
    ".rtf" => "application/rtf",
    ".txt" => "text/plain",
    ".webp" => "image/webp",
    ".xlsx" => "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
  }.freeze

  def validate_each(record, attribute, uploaded_files)
    uploaded_files = [uploaded_files] unless uploaded_files.is_a?(Array)
    uploaded_files.compact_blank!

    if uploaded_files.size > MAX_FILES
      record.errors.add(attribute, :file_count, max_files: MAX_FILES)
    end

    uploaded_files.each do |uploaded_file|
      next if uploaded_file.nil?
      next if uploaded_file.is_a? ActiveStorage::Attached::One

      if uploaded_file.size > MAX_FILE_SIZE
        record.errors.add(attribute, :file_size_too_big, max_allowed_file_size:)
        break
      end

      content_type =
        Marcel::MimeType.for(
          uploaded_file,
          name: uploaded_file.original_filename,
          declared_type: uploaded_file.content_type
        )

      extension = File.extname(uploaded_file.original_filename).downcase

      if !CONTENT_TYPES.values.include?(content_type) || !CONTENT_TYPES.keys.include?(extension)
        record.errors.add(
          attribute,
          :invalid_content_type,
          valid_types: CONTENT_TYPES.keys.sort.join(", ")
        )
        break
      elsif CONTENT_TYPES[extension] != content_type
        record.errors.add attribute, :mismatch_content_type
        break
      end
    end
  end
end
