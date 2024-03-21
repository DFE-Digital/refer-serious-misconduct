require "rails_helper"

RSpec.feature "static pages", type: :system do
  include CommonSteps

  scenario "User visits accessibility page" do
    given_the_service_is_open
    when_i_visit("/accessibility")
    then_i_see("Accessibility statement")
  end

  scenario "User visits cookies page" do
    given_the_service_is_open
    when_i_visit("/cookies")
    then_i_see("Essential cookies")
  end

  scenario "User visits privacy page" do
    given_the_service_is_open
    when_i_visit("/privacy")
    then_i_see("Who we are")
  end

  private

  def when_i_visit(url)
    visit(url)
  end

  def then_i_see(content)
    expect(page).to have_content(content)
  end
end
