require "rails_helper"

RSpec.describe SupportInterface::FeedbackSummaryCardComponent, type: :component do
  subject(:component) { described_class.new(feedback:) }

  let(:feedback) { create(:feedback) }

  before { render_inline(component) }

  around do |example|
    travel_to(Time.zone.local(2000, 12, 28, 13, 59)) do
      example.run
    end
  end

  it "renders id" do
    expect(page).to have_text(feedback.id)
  end

  it "renders card keys" do
    expect(page).to have_text("Satisfaction rating")
    expect(page).to have_text("Improvement suggestion")
    expect(page).to have_text("Contact permission given")
    expect(page).to have_text("Email")
    expect(page).to have_text("Created at")
  end

  it "renders correct data" do
    expect(page).to have_text(feedback.satisfaction_rating)
    expect(page).to have_text(feedback.improvement_suggestion)
    expect(page).to have_text(feedback.contact_permission_given ? "Yes" : "No")
    expect(page).to have_text(feedback.email)
    expect(page).to have_text("1:59pm on 28 December 2000")
  end
end
