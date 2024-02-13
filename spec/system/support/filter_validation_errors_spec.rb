# frozen_string_literal: true
require "rails_helper"

RSpec.feature "Filter Validation Errors" do
  include CommonSteps

  scenario "List validation errors", type: :system do
    given_the_service_is_open
    when_i_login_as_a_case_worker_with_support_permissions_only

    and_multiple_validation_errors_exist
    when_i_visit_the_validation_errors_index_page
    then_i_see_filter_validations_form
    when_i_select_the_relevant_form_object("Teacher Role")
    when_i_select_the_relevant_attribute("Job Title")
    and_i_press_continue
    then_i_see_the_validation_history_page
    and_i_only_see_validation_errors_relevant_to_my_selection
  end

  def and_multiple_validation_errors_exist
    @validation_error1 = create(:validation_error,
                                form_object: "Referrals::TeacherRole::JobTitleForm",
                                details: {"job_title"=>{"value"=>"", "messages"=>["Enter their job title"]}})
    @validation_error2 = create(:validation_error,
                                form_object:  "Referrals::TeacherPersonalDetails::NameForm",
                                details: { "name_has_changed"=>
                                            {"value"=>nil, "messages"=>
                                              ["Select yes if you know them by any other name"]
                                            }}
    )
  end

  def when_i_visit_the_validation_errors_index_page
    click_link "Validation Errors"
  end

  def then_i_see_filter_validations_form
    expect(page).to have_text("Filter by form")
  end

  def when_i_select_the_relevant_form_object(form_object_string)
    select form_object_string, from: "filter-validation-form-form-object-field"
  end

  def when_i_select_the_relevant_attribute(attribute_string)
    select attribute_string, from: "filter-validation-form-attribute-field"
  end

  def then_i_see_the_validation_errors
    expect(page).to have_text(@validation_error.form_object.demodulize.underscore.humanize)
  end

  def then_i_see_the_validation_history_page
    expect(page).to have_text("Validation errors for Teacher Role / Job Title Form - Job Title")
  end

  def and_i_only_see_validation_errors_relevant_to_my_selection
    expect(page).to have_text("Enter their job title")
    expect(page).not_to have_text("Select yes if you know them by any other name")
  end

  def and_i_press_continue
    click_button "Continue"
  end
end
