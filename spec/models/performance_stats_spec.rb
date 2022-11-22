require "rails_helper"

RSpec.describe PerformanceStats, type: :model do
  describe "#request_counts_by_day" do
    subject(:request_counts_by_day) { performance_stats.request_counts_by_day }

    let(:performance_stats) { described_class.new }

    before do
      travel_to Time.zone.local(2022, 11, 22, 12, 0, 0)
      create(:eligibility_check, :complete)
      create(:eligibility_check, :not_unsupervised)
      create(:eligibility_check)
      travel_to Time.zone.local(2022, 11, 29, 12, 0, 0)
    end

    after { travel_back }

    it "returns the request counts for the last 8 days" do
      expect(request_counts_by_day.size).to eq(8)
    end

    it "returns the correct number of requests for today" do
      expect(request_counts_by_day.last).to eq(
        [
          7.days.ago.to_fs(:weekday_day_and_month),
          {
            complete_count: 1,
            screened_out_count: 1,
            incomplete_count: 1,
            total: 3
          }
        ]
      )
    end

    it "returns default values for days without a request" do
      expect(request_counts_by_day.second).to eq(
        [
          1.day.ago.to_fs(:weekday_day_and_month),
          {
            complete_count: 0,
            screened_out_count: 0,
            incomplete_count: 0,
            total: 0
          }
        ]
      )
    end
  end

  describe "#total_requests_by_day" do
    subject(:total_requests_by_day) { performance_stats.total_requests_by_day }

    let(:performance_stats) { described_class.new }

    it "returns zero values by default" do
      expect(total_requests_by_day).to eq(
        {
          complete_count: 0,
          screened_out_count: 0,
          incomplete_count: 0,
          total: 0
        }
      )
    end

    context "when there have been checks" do
      before do
        create(:eligibility_check, :complete)
        create(:eligibility_check, :not_unsupervised)
        create(:eligibility_check)
        create(:eligibility_check, is_teacher: "yes")
      end

      it "returns the totals for the period" do
        expect(total_requests_by_day).to eq(
          {
            complete_count: 1,
            screened_out_count: 1,
            incomplete_count: 2,
            total: 4
          }
        )
      end
    end
  end

  describe "#total_requests_by_month" do
    subject(:total_requests_by_month) do
      performance_stats.total_requests_by_month
    end

    let(:performance_stats) { described_class.new }

    it "returns zero values by default" do
      expect(total_requests_by_month).to eq(
        {
          complete_count: 0,
          screened_out_count: 0,
          incomplete_count: 0,
          total: 0
        }
      )
    end

    context "when there have been checks" do
      before do
        create(:eligibility_check, :complete)
        create(:eligibility_check, :not_unsupervised)
        create(:eligibility_check)
      end

      it "returns the totals for the period" do
        expect(total_requests_by_month).to eq(
          {
            complete_count: 1,
            screened_out_count: 1,
            incomplete_count: 1,
            total: 3
          }
        )
      end
    end
  end
end
