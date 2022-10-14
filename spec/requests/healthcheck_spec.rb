require "rails_helper"

RSpec.describe "Health check", type: :request do
  describe "GET /health" do
    it "responds successfully" do
      get "/health"
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /health/all" do
    it "responds successfully" do
      get "/health/all"
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /health/postgresql" do
    it "responds successfully" do
      get "/health/postgresql"
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /health/version" do
    it "responds successfully" do
      get "/health/version"
      expect(response).to have_http_status(:ok)
    end
  end
end
