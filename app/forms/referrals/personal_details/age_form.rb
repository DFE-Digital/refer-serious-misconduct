# frozen_string_literal: true
module Referrals
  module PersonalDetails
    class AgeForm
      include ActiveModel::Model

      attr_accessor :referral
      attr_writer :age_known, :approximate_age, :date_of_birth

      validates :age_known, inclusion: { in: %w[yes approximate no] }
      validates :approximate_age,
                presence: true,
                if: -> { age_known == "approximate" }
      validates :date_of_birth, presence: true, if: -> { age_known == "yes" }

      def age_known
        @age_known ||= referral.age_known
      end

      def approximate_age
        @approximate_age ||= referral.approximate_age
      end

      def date_of_birth
        @date_of_birth ||= referral.date_of_birth
      end

      def save(params = {})
        return save_date_of_birth(params) if age_known == "yes"

        save_age
      end

      def save_age
        return false if invalid?

        age_attrs = { age_known:, approximate_age: nil, date_of_birth: nil }
        age_attrs.merge!(approximate_age:) if age_known == "approximate"

        referral.update(age_attrs)
      end

      def save_date_of_birth(params = {})
        date_fields = [
          params["date_of_birth(1i)"],
          params["date_of_birth(2i)"],
          params["date_of_birth(3i)"]
        ]

        date_fields.map! { |f| f&.to_s&.strip }

        # Use a struct instead of a date object to maintain what the user typed in,
        # and not transform the fields into other data types like integers that
        # Date.new is capable of accepting.
        self.date_of_birth = Struct.new(:year, :month, :day).new(*date_fields)

        year, month, day = date_fields.map { |f| word_to_number(f) }.map(&:to_i)

        if day.zero? && month.zero? && year.zero?
          errors.add(:date_of_birth, :blank)
          return false
        end

        if day.zero?
          errors.add(:date_of_birth, :missing_day)
          return false
        end

        month_is_a_word = month.zero? && date_fields[1].length.positive?
        month = word_to_month(date_fields[1]) if month_is_a_word

        if month.zero?
          errors.add(:date_of_birth, :missing_month)
          return false
        end

        if year < 1000
          errors.add(:date_of_birth, :missing_year)
          return false
        end

        if year < 1900
          errors.add(:date_of_birth, :born_after_1900)
          return false
        end

        if year > Time.zone.today.year
          errors.add(:date_of_birth, :in_the_future)
          return false
        end

        begin
          self.date_of_birth = Date.new(year, month, day)
        rescue Date::Error
          errors.add(:date_of_birth, :invalid)
          return false
        end

        if date_of_birth > 16.years.ago
          errors.add(:date_of_birth, :inclusion)
          return false
        end

        referral.update(age_known:, date_of_birth:, approximate_age: nil)
      end

      private

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
  end
end
