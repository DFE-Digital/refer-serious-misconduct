# frozen_string_literal: true
require "rails_helper"

RSpec.feature "Manage referrals" do
  include CommonSteps

  scenario "Case worker with manage_referrals permission views a public referral",
           type: :system do
    given_the_service_is_open
    and_the_referral_form_feature_is_active
    and_the_eligibility_screener_feature_is_active
    and_there_is_an_existing_public_referral

    when_i_login_as_a_case_worker_with_management_permissions_only
    then_i_see_manage_referrals_page

    when_i_visit_staff_sign_in_page
    then_i_see_manage_referrals_page

    and_i_visit_the_referral
    then_i_see_the_referral_summary
    and_i_see_the_personal_details_section
    and_i_see_the_employment_details_section
    and_i_see_the_allegation_details_section
    and_i_see_the_evidence_section
    and_i_see_the_referrer_details_section
    and_there_are_no_employer_only_sections
  end

  private

  def and_there_is_an_existing_public_referral
    @referral = create(:referral, :public_complete)
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
      expect(page).not_to have_content("Do they have qualified teacher status?")
    end
  end

  def and_i_see_the_employment_details_section
    expect(page).to have_content("Employment details")
    within("#employment_details") do
      expect(page).to have_content("Job title")
      expect(page).to have_content("Teacher")
      expect(page).to have_content("Main duties")
      expect(page).not_to have_content("Organisation")
      expect(page).not_to have_content("Job start date")
      expect(page).not_to have_content("Job end date")
      expect(page).not_to have_content("Reason they left the job")
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

  def and_i_see_the_referrer_details_section
    expect(page).to have_content("Referrer details")
    within("#referrer_details") do
      expect(page).to have_content("First name")
      expect(page).to have_content("Jane")
      expect(page).to have_content("Last name")
      expect(page).to have_content("Smith")
      expect(page).not_to have_content("Job title")
      expect(page).to have_content("Email address")
      expect(page).to have_content(@referral.user.email)
      expect(page).to have_content("Phone number")
      expect(page).to have_content("01234567890")
      expect(page).not_to have_content("Employer")
    end
  end

  def and_there_are_no_employer_only_sections
    expect(page).not_to have_content("Other employment details")
    expect(page).not_to have_content("Previous allegation details")
  end

  def when_i_visit_the_referral
    visit manage_interface_referral_path(Referral.last)
  end
  alias_method :and_i_visit_the_referral, :when_i_visit_the_referral
end
