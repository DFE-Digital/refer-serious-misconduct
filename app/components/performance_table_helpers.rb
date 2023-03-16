module PerformanceTableHelpers
  def count_to_percent(attributes, numerator_key)
    if attributes[:total].zero?
      ""
    else
      percentage = number_to_percentage(100 * attributes[numerator_key].fdiv(attributes[:total]), precision: 0)
      "(#{percentage})"
    end
  end

  def number_with_percentage_cell(counts, key, label: nil)
    [
      number_with_delimiter(counts[key]),
      label&.pluralize(counts[key]),
      '<span class="govuk-hint govuk-!-font-size-16">',
      count_to_percent(counts, key),
      "</span>"
    ].compact.join(" ").html_safe
  end
end
