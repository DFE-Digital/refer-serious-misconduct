# frozen_string_literal: true
class EligibilityPerformanceTableComponent < ViewComponent::Base
  include PerformanceTableHelpers
  include ActiveModel::Model

  attr_accessor :grouped_request_counts, :since, :total_grouped_requests

  def call
    govuk_table(classes: "app-performance-table") do |table|
      table.with_head do |head|
        head.with_row do |row|
          row.with_cell(
            header: true,
            text: "Date",
            classes: "app-performance-table-column-divider app-performance-table-date-column"
          )
          row.with_cell(header: true, text: "Complete")
          row.with_cell(header: true, text: "Screened out")
          row.with_cell(
            header: true,
            text: "Did not finish",
            classes: "app-performance-table-column-divider"
          )
          row.with_cell(header: true, text: "Total", classes: "govuk-!-padding-left-2")
        end
      end
      table.with_body do |body|
        grouped_request_counts.map do |period_label, counts|
          body.with_row do |row|
            row.with_cell(classes: "app-performance-table-column-divider") { period_label }
            row.with_cell { number_with_percentage_cell(counts, :complete_count) }
            row.with_cell { number_with_percentage_cell(counts, :screened_out_count) }
            row.with_cell(classes: "app-performance-table-column-divider") do
              number_with_percentage_cell(counts, :incomplete_count)
            end
            row.with_cell { "#{number_with_delimiter(counts[:total])} checks" }
          end
        end
        body.with_row(classes: "app-performance-table-total-row") do |row|
          row.with_cell(header: true, classes: "app-performance-table-column-divider") do
            "Total (#{since})"
          end
          row.with_cell { number_with_percentage_cell(total_grouped_requests, :complete_count) }
          row.with_cell { number_with_percentage_cell(total_grouped_requests, :screened_out_count) }
          row.with_cell(classes: "app-performance-table-column-divider") do
            number_with_percentage_cell(total_grouped_requests, :incomplete_count)
          end
          row.with_cell { "#{number_with_delimiter(total_grouped_requests[:total])} checks" }
        end
      end
    end
  end
end
