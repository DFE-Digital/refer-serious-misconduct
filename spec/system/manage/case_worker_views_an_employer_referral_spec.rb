# frozen_string_literal: true
require "rails_helper"

RSpec.feature "Manage referrals" do
  include CommonSteps

  scenario "Case worker views an employer referral" do
    given_the_service_is_open
    and_the_referral_form_feature_is_active
    and_the_eligibility_screener_feature_is_active
    and_staff_http_basic_is_active
    and_i_am_authorized_as_a_case_worker
    and_there_is_an_existing_employer_referral

    when_i_visit_the_referral
    then_i_see_the_referral_summary
    and_i_see_the_personal_details_section
    and_i_see_the_employment_details_section
    and_i_see_the_other_employment_details_section
    and_i_see_the_allegation_details_section
    and_i_see_the_evidence_section
    and_i_see_the_previous_allegation_details_section
    and_i_see_the_referrer_details_section
  end

  private

  def and_i_am_authorized_as_a_case_worker
    page.driver.basic_authorize(
      ENV.fetch("SUPPORT_USERNAME", "test"),
      ENV.fetch("SUPPORT_PASSWORD", "test")
    )
  end

  def and_there_is_an_existing_employer_referral
    @referral = create(:referral, :employer_complete)
  end

  def then_i_see_the_referral_summary
    expect(page).to have_content("Summary")
    within("#summary") do
      expect(page).to have_content(Referral.last.id)
      expect(page).to have_content(
        Referral.last.created_at.to_fs(:day_month_year_time)
      )
    end
  end

  def and_i_see_the_personal_details_section
    expect(page).to have_content("Personal details")
    within("#personal_details") do
      expect(page).to have_content("John")
      expect(page).to have_content("Smith")
      expect(page).to have_content("Do they have qualified teacher status?")
      expect(page).to have_content("Yes")
    end
  end

  def and_i_see_the_employment_details_section
    expect(page).to have_content("Employment details")
    within("#employment_details") do
      expect(page).to have_content("Job title")
      expect(page).to have_content("Teacher")
      expect(page).to have_content("Main duties")
      expect(page).to have_content("Organisation")
      expect(page).to have_content("1 Example Street")
      expect(page).to have_content("Example City")
      expect(page).to have_content("AB1 2CD")
      expect(page).to have_content("Job start date")
      expect(page).to have_content(
        @referral.role_start_date.to_fs(:long_ordinal_uk)
      )
      expect(page).to have_content("Job end date")
      expect(page).to have_content(
        @referral.role_end_date.to_fs(:long_ordinal_uk)
      )
      expect(page).to have_content("Reason they left the job")
      expect(page).to have_content("Dismissed")
    end
  end

  def and_i_see_the_other_employment_details_section
    expect(page).to have_content("Other employment details")
    within("#other_employment_details") do
      expect(page).to have_content("Organisation")
      expect(page).to have_content("Different School")
      expect(page).to have_content("2 Different Street")
      expect(page).to have_content("Example Town")
      expect(page).to have_content("AB1 2CD")
    end
  end

  def and_i_see_the_allegation_details_section
    expect(page).to have_content("Allegation details")
    within("#allegation_details") do
      expect(page).to have_content("Allegation details")
      expect(page).to have_content("They were rude to a child")
      expect(page).to have_content(
        "Have you told the Disclosure and Barring Service (DBS)?"
      )
      expect(page).to have_content("Yes")
    end
  end

  def and_i_see_the_evidence_section
    expect(page).to have_content("Evidence and supporting information")
    within("#evidence") { expect(page).to have_link("upload1.pdf") }
  end

  def and_i_see_the_previous_allegation_details_section
    expect(page).to have_content("Previous allegation details")
    within("#previous_allegation_details") do
      expect(page).to have_content("Has there been any previous misconduct?")
      expect(page).to have_content("Yes")
      expect(page).to have_content("Previous allegation details")
      expect(page).to have_content("They were rude to a child")
    end
  end

  def and_i_see_the_referrer_details_section
    expect(page).to have_content("Referrer details")
    within("#referrer_details") do
      expect(page).to have_content("First name")
      expect(page).to have_content("Jane")
      expect(page).to have_content("Last name")
      expect(page).to have_content("Smith")
      expect(page).to have_content("Job title")
      expect(page).to have_content("Headteacher")
      expect(page).to have_content("Email address")
      expect(page).to have_content(@referral.user.email)
      expect(page).to have_content("Phone number")
      expect(page).to have_content("01234567890")
      expect(page).to have_content("Employer")
      expect(page).to have_content("Example School")
      expect(page).to have_content("1 Example Street")
      expect(page).to have_content("Example City")
      expect(page).to have_content("AB1 2CD")
    end
  end

  def when_i_visit_the_referral
    visit manage_interface_referral_path(Referral.last)
  end
end
