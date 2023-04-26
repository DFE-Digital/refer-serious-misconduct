require "rails_helper"

RSpec.describe LogStashFormatter do
  subject(:formatter) { described_class.new }

  let(:info_level_log) do
    {
      host: "Octavians-MBP-2",
      application: "Semantic Logger",
      environment: "development",
      time: "2023-03-23T11:44:30.757+00:00",
      level: :info,
      level_index: 2,
      pid: 6092,
      thread: "puma srv tp 002",
      duration_ms: nil,
      duration: 253.90900003910065,
      name: "Users::SessionsController",
      message: "Completed #new",
      payload: {
        controller: "Users::SessionsController",
        action: "new",
        format: "HTML",
        method: "GET",
        path: "/users/session/new",
        status: 200,
        view_runtime: 77.42,
        db_runtime: 41.77,
        allocations: 47_495,
        status_message: "OK"
      },
      type: "rails"
    }
  end

  let(:fatal_level_log) do
    {
      host: "Octavians-MBP-2",
      application: "Semantic Logger",
      environment: "development",
      time: "2023-03-23T12:17:42.923+00:00",
      level: :fatal,
      level_index: 5,
      pid: 6092,
      thread: "puma srv tp 004",
      line: 93,
      name: "Rails",
      exception: {
        name: "ActionController::RoutingError",
        message: "No route matches [GET] \"/users/referrals/15\"",
        stack_trace: [
          "stack trace line 1",
          "stack trace line 2",
          "stack trace line 3",
          "stack trace line 4",
          "stack trace line 5"
        ]
      },
      type: "rails",
      duration: nil,
      duration_ms: nil
    }
  end

  before { allow_any_instance_of(described_class).to receive(:hash).and_return(log) }

  describe "#format_exception" do
    context "when there is an info log" do
      let(:log) { info_level_log }

      it "does not format the log" do
        formatter.format_exception

        expect(formatter.hash).to eq(log)
      end
    end

    context "when there is an fatal log" do
      let(:log) { fatal_level_log }

      it "does adds the error message under the `message` key in the log" do
        formatter.format_exception

        expect(formatter.hash[:message]).to eq(
          'Exception occurred: No route matches [GET] "/users/referrals/15"'
        )
      end
    end
  end

  describe "#format_stacktrace" do
    let(:log) { fatal_level_log }

    it "trims the stacktrace to make the whole log object smaller" do
      formatter.format_stacktrace

      expect(formatter.hash[:exception]).to eq(
        {
          name: "ActionController::RoutingError",
          message: "No route matches [GET] \"/users/referrals/15\""
        }
      )

      expect(formatter.hash[:stacktrace]).to eq(
        ["stack trace line 1", "stack trace line 2", "stack trace line 3"]
      )

      expect(formatter.hash[:exception][:stack_trace]).to be_nil
    end
  end

  describe "#format_add_type" do
    let(:log) { info_level_log }

    it "adds the app type" do
      formatter.format_add_type

      expect(formatter.hash[:type]).to eq("rails")
    end
  end

  describe "#format_add_hosting_env" do
    let(:log) { info_level_log }

    it "adds the hosting environment" do
      formatter.format_add_hosting_env

      expect(formatter.hash[:hosting_environment]).to eq(ENV["HOSTING_ENVIRONMENT_NAME"])
    end
  end

  describe "#format_add_host_domain" do
    let(:log) { info_level_log }

    it "adds the host domain" do
      formatter.format_add_host_domain

      expect(formatter.hash[:host]).to eq(ENV["HOSTING_DOMAIN"])
    end
  end
end
