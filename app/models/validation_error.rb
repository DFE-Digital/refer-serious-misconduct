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
end
