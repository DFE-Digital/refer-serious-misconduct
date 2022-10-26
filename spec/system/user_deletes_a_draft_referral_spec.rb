# frozen_string_literal: true
require "rails_helper"

RSpec.feature "User deletes a draft referral" do
  scenario "User deletes a draft referral" do
    given_the_service_is_open
    and_the_employer_form_feature_is_active

    when_i_make_a_new_referral
    and_i_dont_want_to_continue
    and_i_confirm_deletion
    then_the_new_referral_is_discarded

    when_i_have_an_existing_referral
    and_i_visit_the_referral_summary
    and_i_dont_want_to_continue
    and_i_confirm_deletion
    then_the_draft_referral_is_deleted
  end

  private

  def given_the_service_is_open
    FeatureFlags::FeatureFlag.activate(:service_open)
  end

  def and_the_employer_form_feature_is_active
    FeatureFlags::FeatureFlag.activate(:employer_form)
  end

  def when_i_have_an_existing_referral
    @referral = Referral.create!
  end

  def and_i_visit_the_referral_summary
    visit edit_referral_path(@referral)
  end

  def when_i_make_a_new_referral
    visit new_referral_path
  end

  def and_i_dont_want_to_continue
    find(
      "a.govuk-button",
      text: "Delete your draft referral",
      visible: false
    ).trigger("click")
  end

  def and_i_confirm_deletion
    click_on "Yes I’m sure – delete it"
  end

  def then_the_draft_referral_is_deleted
    expect { @referral.reload }.to raise_error(ActiveRecord::RecordNotFound)
    expect(page).to have_content("Your draft has been deleted")
  end

  def then_the_new_referral_is_discarded
    expect(page).to have_content("Your draft has been deleted")
  end
end
