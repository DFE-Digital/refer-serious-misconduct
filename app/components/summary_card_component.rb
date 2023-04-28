class SummaryCardComponent < ViewComponent::Base
  attr_reader :rows

  def initialize(rows:, editable: true, ignore_editable: [])
    super
    rows = transform_hash(rows) if rows.is_a?(Hash)
    @rows = rows_including_actions_if_editable(rows, editable, ignore_editable)
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
