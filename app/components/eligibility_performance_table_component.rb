# frozen_string_literal: true
class EligibilityPerformanceTableComponent < ViewComponent::Base
  include PerformanceTableHelpers
  include ActiveModel::Model

  attr_accessor :grouped_request_counts, :since, :total_grouped_requests

  def call
    govuk_table(classes: "app-performance-table") do |table|
      table.head do |head|
        head.row do |row|
          row.cell(
            header: true,
            text: "Date",
            classes: "app-performance-table-column-divider app-performance-table-date-column"
          )
          row.cell(header: true, text: "Complete")
          row.cell(header: true, text: "Screened out")
          row.cell(
            header: true,
            text: "Did not finish",
            classes: "app-performance-table-column-divider"
          )
          row.cell(header: true, text: "Total", classes: "govuk-!-padding-left-2")
        end
      end
      table.body do |body|
        grouped_request_counts.map do |period_label, counts|
          body.row do |row|
            row.cell(classes: "app-performance-table-column-divider") { period_label }
            row.cell { number_with_percentage_cell(counts, :complete_count) }
            row.cell { number_with_percentage_cell(counts, :screened_out_count) }
            row.cell(classes: "app-performance-table-column-divider") do
              number_with_percentage_cell(counts, :incomplete_count)
            end
            row.cell { "#{number_with_delimiter(counts[:total])} checks" }
          end
        end
        body.row(classes: "app-performance-table-total-row") do |row|
          row.cell(header: true, classes: "app-performance-table-column-divider") do
            "Total (#{since})"
          end
          row.cell { number_with_percentage_cell(total_grouped_requests, :complete_count) }
          row.cell { number_with_percentage_cell(total_grouped_requests, :screened_out_count) }
          row.cell(classes: "app-performance-table-column-divider") do
            number_with_percentage_cell(total_grouped_requests, :incomplete_count)
          end
          row.cell { "#{number_with_delimiter(total_grouped_requests[:total])} checks" }
        end
      end
    end
  end
end
