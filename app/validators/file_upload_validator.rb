class FileUploadValidator < ActiveModel::EachValidator
  MAX_FILE_SIZE = 25.megabytes

  CONTENT_TYPES = {
    ".pdf" => "application/pdf",
    ".doc" => "application/msword",
    ".docx" =>
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
    ".txt" => "text/plain"
  }.freeze

  def validate_each(record, attribute, uploaded_files)
    uploaded_files = [uploaded_files] unless uploaded_files.is_a?(Array)

    uploaded_files.compact_blank.each do |uploaded_file|
      next if uploaded_file.nil?

      if uploaded_file.size >= MAX_FILE_SIZE
        record.errors.add attribute, :file_size_too_big
        break
      end

      content_type =
        Marcel::MimeType.for(
          uploaded_file,
          name: uploaded_file.original_filename,
          declared_type: uploaded_file.content_type
        )

      extension = File.extname(uploaded_file.original_filename).downcase

      if !CONTENT_TYPES.values.include?(content_type) ||
           !CONTENT_TYPES.keys.include?(extension)
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
