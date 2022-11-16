# frozen_string_literal: true
module ValidatedDate
  extend ActiveSupport::Concern

  included do
    def validated_date(
      date_params:,
      attribute:,
      date_of_birth: false,
      in_the_future: false
    )
      date_fields = [
        date_params["#{attribute}(1i)"],
        date_params["#{attribute}(2i)"],
        date_params["#{attribute}(3i)"]
      ]

      date_fields.map! { |f| f&.to_s&.strip }

      # Use a struct instead of a date object to maintain what the user typed in,
      # and not transform the fields into other data types like integers that
      # Date.new is capable of accepting.
      send("#{attribute}=", Struct.new(:year, :month, :day).new(*date_fields))

      year, month, day = date_fields.map { |f| word_to_number(f) }.map(&:to_i)

      if day.zero? && month.zero? && year.zero?
        errors.add(attribute, :blank)
        return false
      end

      if day.zero?
        errors.add(attribute, :missing_day)
        return false
      end

      month_is_a_word = month.zero? && date_fields[1].length.positive?
      month = word_to_month(date_fields[1]) if month_is_a_word

      if month.zero?
        errors.add(attribute, :missing_month)
        return false
      end

      if year < 1000
        errors.add(attribute, :missing_year)
        return false
      end

      begin
        send("#{attribute}=", Date.new(year, month, day))
      rescue Date::Error
        errors.add(attribute, :invalid)
        return false
      end

      return true unless date_of_birth || !in_the_future

      if year > Time.zone.today.year
        errors.add(attribute, :in_the_future)
        return false
      end

      return true unless date_of_birth

      if year < 1900
        errors.add(attribute, :born_after_1900)
        return false
      end

      if send(attribute) > 16.years.ago
        errors.add(attribute, :inclusion)
        return false
      end

      true
    end
  end

  def word_to_number(field)
    return field if field.is_a? Integer

    words = {
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
    }

    words[field.downcase.to_sym] || field
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
