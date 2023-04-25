module ValidationTracking
  extend ActiveSupport::Concern
  include ActiveModel::Attributes
  include ActiveModel::Validations::Callbacks

  included do
    after_validation :track_validation_error, if: -> { validation_tracking && errors.any? }

    attribute :validation_tracking, :boolean, default: true
  end

  def track_validation_error
    ValidationError.create!(form_object: self.class.name, details: validation_error_details.to_h)
  end

  def validation_error_details
    errors.messages.map do |field, messages|
      [field, { messages:, value: filtered_field_value(field) }]
    end
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
    return field.to_s.delete("section.") if field.to_s.start_with?("section.")

    public_send(field)
  end
end
