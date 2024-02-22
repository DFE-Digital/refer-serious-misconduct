class FilterValidationForm
  include ValidationErrorHelper
  include ActiveModel::Model
  include CustomAttrs

  attr_accessor :validation_errors
  validates :form_object, presence: true

  def grouped_counts
    @grouped_counts ||= ValidationError.group(:form_object).count
  end

  def form_objects_select
    @form_objects_select ||= grouped_counts.map { |key, _value|
      OpenStruct.new(id: key, name: humanized_form_object(key))
    }.append(OpenStruct.new(id: "", name: "All"))
  end

  def grouped_column_error_counts
    ValidationError.list_of_distinct_errors_with_count
  end

  def attribute_select
    attributes = grouped_column_error_counts.map do |column|
       OpenStruct.new(id: column[0][1], name: column[0][1].underscore.titleize.gsub('.', ' '))
    end
    attributes.append(OpenStruct.new(id: "", name: "All"))
    attributes.uniq
  end
end