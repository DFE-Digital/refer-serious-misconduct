# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Support", type: :system do
  it "visiting the support interface" do
    when_i_am_authorized_as_a_support_user
    and_i_visit_the_support_page
    then_i_see_the_support_page

    when_i_visit_the_features_page
    then_i_see_the_feature_page
  end

  private

  def when_i_am_authorized_as_a_support_user
    page.driver.basic_authorize("test", "test")
  end

  def and_i_visit_the_support_page
    visit support_interface_path
  end

  def then_i_see_the_support_page
    expect(page).to have_current_path(support_interface_path)
  end

  def when_i_visit_the_features_page
    visit support_interface_feature_flags_path
  end

  def then_i_see_the_feature_page
    expect(page).to have_content("Features")
  end
end
