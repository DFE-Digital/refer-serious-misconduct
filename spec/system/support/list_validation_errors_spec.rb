# frozen_string_literal: true
require "rails_helper"

RSpec.feature "Validation Errors" do
  include CommonSteps

  scenario "List validation errors", type: :system do
    given_the_service_is_open
    when_i_login_as_a_case_worker_with_support_permissions_only

    and_a_validation_error_exists
    when_i_visit_the_validation_errors_index_page
    then_i_see_the_validation_errors
  end

  def and_a_validation_error_exists
    @validation_error = create(:validation_error)
  end

  def when_i_visit_the_validation_errors_index_page
    click_link "Validation Errors"
  end

  def then_i_see_the_validation_errors
    expect(page).to have_text(@validation_error.form_object.demodulize.underscore.humanize)
  end
end
