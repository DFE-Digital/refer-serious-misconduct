class ValidationError < ApplicationRecord
  validates :form_object, presence: true

  def self.list_of_distinct_errors_with_count
    distinct_errors =
      all.flat_map do |e|
        e.details.flat_map do |attribute, details|
          details["messages"].map { |message| [e.form_object, attribute, message] }
        end
      end

    distinct_errors.tally.sort_by { |_a, b| b }.reverse
  end

  def self.extract_attribute_from_errors(errors, attribute)
    errors.filter_map do |error|
      if error.details[attribute]
        OpenStruct.new(
          created_at: error.created_at,
          messages: error.details.dig(attribute, "messages"),
          value: error.details.dig(attribute, "value")
        )
      end
    end
  end

  def self.extract_all_attributes_from_errors(errors)
    errors.filter_map do |error|
      attribute = error.details.keys.first
      OpenStruct.new(
        created_at: error.created_at,
        messages: error.details.dig(attribute, "messages"),
        value: error.details.dig(attribute, "value")
      )
    end
  end

  def self.filter_on_attributes(errors, attribute)
    if attribute.empty?
      extract_all_attributes_from_errors(errors)
    else
      extract_attribute_from_errors(errors, attribute)
    end
  end
end
