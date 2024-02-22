module ValidationTracking
  extend ActiveSupport::Concern
  include ActiveModel::Attributes
  include ActiveModel::Validations::Callbacks

  included do
    after_validation :track_validation_error, if: -> { validation_tracking && errors.any? }

    attribute :validation_tracking, :boolean, default: true
  end

  def valid_without_tracking?
    without_tracking { valid? }
  end

  def without_tracking
    self.validation_tracking = false
    yield
  ensure
    self.validation_tracking = true
  end

  def track_validation_error
    ValidationError.create!(form_object: self.class.name, details: validation_error_details.to_h)
  end

  def validation_error_details
    errors.messages.map { |field, messages| [field, { messages:, value: value_for_field(field) }] }
  end

  # Should we need to filter out any PII from the validation error details in future, we can do so here.
  def filtered_field_value(field)
    ActiveSupport::ParameterFilter.new(Rails.application.config.filter_parameters).filter(
      field => value_for_field(field)
    )[
      field
    ]
  end

  def value_for_field(field)
    return if field == :base
    return if field.to_s.start_with?("section.")

    value = public_send(field)

    if value.instance_of?(Array)
      count = value.count {|file| file.size >= FileUploadValidator::MAX_FILE_SIZE }
      value = value.map do |upload|
        if upload.instance_of?(ActionDispatch::Http::UploadedFile)
          UploadWrapper.new(upload:, count:)
        else
          upload
        end
      end
    end

    value
  end
end
