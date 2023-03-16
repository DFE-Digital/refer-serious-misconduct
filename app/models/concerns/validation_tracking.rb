module ValidationTracking
  extend ActiveSupport::Concern
  include ActiveModel::Validations::Callbacks

  included { after_validation :track_validation_error, if: -> { errors.any? } }

  def track_validation_error
    ValidationError.create!(form_object: self.class.name, details: validation_error_details.to_h)
  end

  def validation_error_details
    errors.messages.map { |field, messages| [field, { messages:, value: filtered_field_value(field) }] }
  end

  def filtered_field_value(field)
    ActiveSupport::ParameterFilter.new(Rails.application.config.filter_parameters).filter(
      field => value_for_field(field)
    )[
      field
    ]
  end

  def value_for_field(field)
    return "base" if field == :base

    public_send(field)
  end
end
