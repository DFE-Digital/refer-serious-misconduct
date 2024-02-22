require "rails_helper"

RSpec.describe "Support" do
  include CommonSteps

  scenario "a staff user with developer permissions can visit the developer interface", type: :system do
    given_the_service_is_open
    when_i_login_as_staff_with_permissions(view_support: true, developer: true)
    then_i_see_the_staff_index
    and_i_visit_the_developer_features_page
    then_i_see_the_developer_features_page
  end

  private

  def and_i_visit_the_developer_features_page
    click_link "Features"
  end

  def then_i_see_the_developer_features_page
    expect(page).to have_content("Service open")
  end
end
