module FileSizeHelper
  def file_size(attachment)
    ActiveSupport::NumberHelper.number_to_human_size(
      attachment.byte_size
    ).delete(" ")
  end

  def max_allowed_file_size
    ActiveSupport::NumberHelper.number_to_human_size(
      FileUploadValidator::MAX_FILE_SIZE
    ).delete(" ")
  end
end
