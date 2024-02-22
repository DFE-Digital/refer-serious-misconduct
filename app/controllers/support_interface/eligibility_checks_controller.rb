require "csv"
module SupportInterface
  class EligibilityChecksController < SupportInterfaceController
    def index
      respond_to do |format|
        format.html { @pagy, @eligibility_checks = pagy(EligibilityCheck.order(updated_at: :desc)) }
        format.csv { stream_csv }
      end
    end

    private

    def stream_csv
      write_response_headers
      write_csv_header_row
      write_csv_rows
    end

    def write_response_headers
      response.headers.delete("Content-Length")
      response.headers["Cache-Control"] = "no-cache"
      response.headers["Content-Type"] = "text/csv"
      response.headers[
        "Content-Disposition"
      ] = "attachment; filename=eligibility-checks-#{Time.zone.now.to_i}.csv"
    end

    def write_csv_header_row
      response.stream.write(
        CSV.generate_line(
          %w[
            id
            reporting_as
            complained
            is_teacher
            teaching_in_england
            serious_misconduct
            eligibility_check_started
            eligibility_check_last_updated
            draft_referral_created
            referral_submitted
          ]
        )
      )
    end

    def write_csv_rows
      EligibilityCheck
        .includes(:referral)
        .order(:updated_at)
        .find_each { |check| response.stream.write(csv_row(check)) }
    end

    def csv_row(check)
      CSV.generate_line(
        [
          check.id,
          check.reporting_as,
          check.format_complained,
          check.is_teacher,
          check.teaching_in_england,
          check.serious_misconduct,
          check.updated_at&.strftime("%d/%m/%Y"),
          check.created_at&.strftime("%d/%m/%Y"),
          check.referral&.created_at&.strftime("%d/%m/%Y"),
          check.referral&.submitted_at&.strftime("%d/%m/%Y")
        ]
      )
    end
  end
end
