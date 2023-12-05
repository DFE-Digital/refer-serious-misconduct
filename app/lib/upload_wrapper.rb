class UploadWrapper
  include ActiveSupport::NumberHelper

  attr_reader :upload

  def initialize(upload:)
    @upload = upload
  end

  def as_json(*args)
    r = super
    r.merge(file_size: number_to_human_size(upload.size, strip_insignificant_zeros: false))
  end
end
