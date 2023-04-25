class SummaryCardComponent < ViewComponent::Base
  attr_reader :section, :rows, :error

  def initialize(rows:, section:, editable: true, ignore_editable: [], error: false)
    super
    rows = transform_hash(rows) if rows.is_a?(Hash)
    @rows = rows_including_actions_if_editable(rows, editable, ignore_editable)
    @section = section
    @error = error
  end

  def show_as_incomplete?
    review ? section.incomplete? : section.questions_incomplete?
  end

  def review
    controller_name == "review" && action_name == "show"
  end

  private

  attr_reader :ignore_editable

  def rows_including_actions_if_editable(rows, editable, ignore_editable)
    rows.map do |row|
      row.tap do |r|
        next if r[:key].in? ignore_editable

        r.delete(:actions) unless editable
      end
    end
  end

  def transform_hash(row_hash)
    row_hash.map { |key, value| { key:, value: } }
  end
end
