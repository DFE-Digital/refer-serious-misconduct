# frozen_string_literal: true
class DateValidator < ActiveModel::EachValidator
  WORDS_FOR_NUMBERS = {
    one: 1,
    two: 2,
    three: 3,
    four: 4,
    five: 5,
    six: 6,
    seven: 7,
    eight: 8,
    nine: 9,
    ten: 10,
    eleven: 11,
    twelve: 12
  }.freeze

  def validate_each(record, attribute, _value)
    date_params_attribute = options[:date_params] || :date_params
    date_params = record.send(date_params_attribute)
    no_params = date_params.blank? || date_params.values.compact_blank.empty?
    existing_attribute = record.send(attribute)

    if no_params
      return true if options[:required] == false

      if existing_attribute.is_a?(Date)
        date_fields = [existing_attribute&.year, existing_attribute&.month, existing_attribute&.day]
      else
        record.errors.add(attribute, :blank)
        return false
      end
    else
      date_fields =
        [
          date_params["#{attribute}(1i)"],
          date_params["#{attribute}(2i)"],
          date_params["#{attribute}(3i)"]
        ].map { |f| f&.to_s&.strip }

      # Use a struct instead of a date object to maintain what the user typed in,
      # and not transform the fields into other data types like integers that
      # Date.new is capable of accepting.
      record.send("#{attribute}=", Struct.new(:year, :month, :day).new(*date_fields))
    end

    year, month, day = date_fields.map { |f| word_to_number(f) }.map(&:to_i)
    month = word_to_month(date_fields[1]) if month.zero? && date_fields[1].present?

    if day.zero? && month.zero? && year.zero? && !options[:required]
      record.errors.add(attribute, :blank)
      return false
    end

    if day.zero?
      record.errors.add(attribute, :missing_day)
      return false
    end

    if month.zero?
      record.errors.add(attribute, :missing_month)
      return false
    end

    if year.zero?
      record.errors.add(attribute, :missing_year)
      return false
    end

    if year < 1000
      record.errors.add(attribute, :incomplete_year)
      return false
    end

    begin
      record.send("#{attribute}=", Date.new(year, month, day))
    rescue Date::Error
      record.errors.add(attribute, :invalid)
      return false
    end

    if options[:not_future] && Date.new(year, month, day) > Time.zone.today
      record.errors.add(attribute, :not_future)
      return false
    end

    if options[:past_century] && !year.between?(1920, Time.zone.today.year)
      record.errors.add(attribute, :past_century)
      return false
    end

    if options[:above_16] && record.send(attribute) > 16.years.ago
      record.errors.add(attribute, :above_16)
      return false
    end

    true
  end

  private

  def word_to_number(field)
    return field if field.is_a? Integer

    WORDS_FOR_NUMBERS[field.downcase.to_sym] || field
  end

  # Attempts to convert Jan, Feb, etc to month numbers. Returns 0 otherwise.
  def word_to_month(raw_month)
    begin
      month = Date.parse(raw_month).month
    rescue Date::Error
      month = 0
    end
    month
  end
end
