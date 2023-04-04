# frozen_string_literal: true
class PerformanceStats
  include ActionView::Helpers::NumberHelper

  LAUNCH_DATE = Date.new(2022, 11, 22).beginning_of_day.freeze

  def daily_percentiles
    @daily_percentiles ||=
      last_n_days.map do |day|
        percentiles = percentiles_by_day[day] || [0, 0, 0]
        date_string = day == Time.zone.today ? "Today" : day.to_fs(:weekday_day_and_month)
        [date_string] +
          percentiles.map { |value| ActiveSupport::Duration.build(value.to_i).inspect }
      end
  end

  def request_counts_by_day
    @request_counts_by_day ||=
      last_n_days.map do |day|
        requests =
          sparse_request_counts_by_day[day] ||
            { total: 0, complete_count: 0, screened_out_count: 0, incomplete_count: 0 }
        date_string =
          (
            if day == Time.current.beginning_of_day
              "Today"
            else
              day.to_fs(:weekday_day_and_month)
            end
          )

        [date_string, requests]
      end
  end

  def request_counts_by_month
    @request_counts_by_month ||=
      sparse_request_counts_by_month.map { |month, counts| [month.to_fs(:month_and_year), counts] }
  end

  def total_percentiles
    @total_percentiles ||=
      begin
        percentiles =
          eligibility_checks
            .unscope(:group)
            .where(serious_misconduct: "yes")
            .pick(
              Arel.sql(
                "percentile_disc(0.90) within group (order by (updated_at - created_at) asc) as percentile_90"
              ),
              Arel.sql(
                "percentile_disc(0.75) within group (order by (updated_at - created_at) asc) as percentile_75"
              ),
              Arel.sql(
                "percentile_disc(0.50) within group (order by (updated_at - created_at) asc) as percentile_50"
              )
            )

        (percentiles || [0, 0, 0]).map { |value| ActiveSupport::Duration.build(value.to_i).inspect }
      end
  end

  def total_requests_by_day
    @total_requests_by_day ||=
      %i[total complete_count screened_out_count incomplete_count].index_with do |key|
        sparse_request_counts_by_day.map(&:last).collect { |attr| attr[key] }.reduce(&:+) || 0
      end
  end

  def total_requests_by_month
    @total_requests_by_month ||=
      %i[total complete_count screened_out_count incomplete_count].index_with do |key|
        sparse_request_counts_by_month.map(&:last).collect { |attr| attr[key] }.reduce(&:+) || 0
      end
  end

  private

  def arel_columns_for_request_counts
    [
      Arel.sql("sum(case when serious_misconduct = 'yes' then 1 else 0 end) as complete_count"),
      Arel.sql(
        "sum(case when serious_misconduct = 'no' or teaching_in_england = 'no' or " \
          "unsupervised_teaching = 'no' then 1 else 0 end) as screened_out_count"
      ),
      Arel.sql(
        "sum(case when serious_misconduct is null and (teaching_in_england is null or teaching_in_england " \
          "<> 'no') and (unsupervised_teaching is null or unsupervised_teaching <> 'no')" \
          " then 1 else 0 end) as incomplete_count"
      ),
      Arel.sql("count(*) as total")
    ]
  end

  def eligibility_checks
    @eligibility_checks ||= EligibilityCheck.previous_7_days.group_by_day
  end

  def last_n_days
    @last_n_days ||= (0..7).map { |n| n.days.ago.beginning_of_day.utc }
  end

  def percentiles_by_day
    @percentiles_by_day ||=
      eligibility_checks
        .complete
        .group("1")
        .pluck(
          Arel.sql("date_trunc('day', created_at) AS day"),
          Arel.sql(
            "percentile_disc(0.90) within group (order by (updated_at - created_at) asc) as percentile_90"
          ),
          Arel.sql(
            "percentile_disc(0.75) within group (order by (updated_at - created_at) asc) as percentile_75"
          ),
          Arel.sql(
            "percentile_disc(0.50) within group (order by (updated_at - created_at) asc) as percentile_50"
          )
        )
        .each_with_object({}) { |row, hash| hash[row[0]] = row.slice(1, 3) }
  end

  def sparse_request_counts_by_day
    @sparse_request_counts_by_day ||=
      eligibility_checks
        .select(Arel.sql("date_trunc('day', created_at) AS day"), *arel_columns_for_request_counts)
        .each_with_object({}) do |row, hash|
          hash[row["day"]] = row.attributes.except("id", "day").symbolize_keys
        end
  end

  def sparse_request_counts_by_month
    @sparse_request_counts_by_month ||=
      begin
        start_date = [LAUNCH_DATE, 12.months.ago.beginning_of_month.beginning_of_day].max

        EligibilityCheck
          .where(created_at: (start_date..))
          .group("date_trunc('month', created_at)")
          .select(
            Arel.sql("date_trunc('month', created_at) AS month"),
            *arel_columns_for_request_counts
          )
          .order(Arel.sql("date_trunc('month', created_at) desc"))
          .each_with_object({}) do |row, hash|
            hash[row["month"]] = row.attributes.except("id", "month").symbolize_keys
          end
      end
  end
end
