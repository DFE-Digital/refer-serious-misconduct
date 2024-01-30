class UploadWrapper
  include ActiveSupport::NumberHelper

  attr_reader :upload, :count

  def initialize(upload:, count:)
    @upload = upload
    @count = count
  end

  def as_json(*args)
    r = super
    r.merge(file_size: number_to_human_size(upload.size, strip_insignificant_zeros: false),
            files_with_errors_count: count)
  end
end
