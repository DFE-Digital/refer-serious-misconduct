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

    context "when the day has requests" do
      subject(:day) { request_counts_by_day.last }

      it "returns the date" do
        expect(day.first).to eq(7.days.ago.to_fs(:weekday_day_and_month))
      end

      it "returns the complete count" do
        expect(day.second[:complete_count]).to eq(1)
      end

      it "returns the incomplete count" do
        expect(day.second[:incomplete_count]).to eq(1)
      end

      it "returns the screened out count" do
        expect(day.second[:screened_out_count]).to eq(1)
      end

      it "returns the total" do
        expect(day.second[:total]).to eq(3)
      end
    end

    context "when the day has no requests" do
      subject(:day) { request_counts_by_day.second }

      it "returns the default complete value" do
        expect(day.second[:complete_count]).to eq(0)
      end

      it "returns the default screened out value" do
        expect(day.second[:screened_out_count]).to eq(0)
      end

      it "returns the default incomplete value" do
        expect(day.second[:incomplete_count]).to eq(0)
      end

      it "returns the default total value" do
        expect(day.second[:total]).to eq(0)
      end
    end
  end

  describe "#total_requests_by_day" do
    subject(:total_requests_by_day) { performance_stats.total_requests_by_day }

    let(:performance_stats) { described_class.new }

    it "returns zero complete by default" do
      expect(total_requests_by_day[:complete_count]).to eq(0)
    end

    it "returns zero screened out by default" do
      expect(total_requests_by_day[:screened_out_count]).to eq(0)
    end

    it "returns zero incomplete by default" do
      expect(total_requests_by_day[:incomplete_count]).to eq(0)
    end

    it "returns zero total by default" do
      expect(total_requests_by_day[:total]).to eq(0)
    end

    context "when there have been checks" do
      before do
        create(:eligibility_check, :complete)
        create(:eligibility_check, :not_unsupervised)
        create(:eligibility_check)
        create(:eligibility_check, is_teacher: "yes")
      end

      it "returns the complete total for the period" do
        expect(total_requests_by_day).to include(complete_count: 1)
      end

      it "returns the screened out total for the period" do
        expect(total_requests_by_day).to include(screened_out_count: 1)
      end

      it "returns the incomplete total for the period" do
        expect(total_requests_by_day).to include(incomplete_count: 2)
      end

      it "returns the total for the period" do
        expect(total_requests_by_day).to include(total: 4)
      end
    end
  end

  describe "#total_requests_by_month" do
    subject(:total_requests_by_month) { performance_stats.total_requests_by_month }

    let(:performance_stats) { described_class.new }

    it "returns zero complete for the month" do
      expect(total_requests_by_month).to include(complete_count: 0)
    end

    it "returns zero incomplete for the month" do
      expect(total_requests_by_month).to include(incomplete_count: 0)
    end

    it "returns zero screened out for the month" do
      expect(total_requests_by_month).to include(screened_out_count: 0)
    end

    it "returns zero total for the month" do
      expect(total_requests_by_month).to include(total: 0)
    end

    context "when there have been checks" do
      before do
        create(:eligibility_check, :complete)
        create(:eligibility_check, :not_unsupervised)
        create(:eligibility_check)
      end

      it "returns the correct complete total for the period" do
        expect(total_requests_by_month).to include(complete_count: 1)
      end

      it "returns the correct screened out total for the period" do
        expect(total_requests_by_month).to include(screened_out_count: 1)
      end

      it "returns the correct incomplete total for the period" do
        expect(total_requests_by_month).to include(incomplete_count: 1)
      end

      it "returns the correct total for the period" do
        expect(total_requests_by_month).to include(total: 3)
      end
    end
  end
end
