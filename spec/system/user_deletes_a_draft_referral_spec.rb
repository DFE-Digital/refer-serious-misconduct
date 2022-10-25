# frozen_string_literal: true
require "rails_helper"

RSpec.feature "User deletes a draft referral" do
  scenario "User deletes a draft referral" do
    given_the_service_is_open
    and_the_employer_form_feature_is_active
    and_i_have_an_existing_referral
    when_i_visit_the_referral_summary
    and_i_dont_want_to_continue
    then_the_draft_referral_is_deleted
  end

  private

  def given_the_service_is_open
    FeatureFlags::FeatureFlag.activate(:service_open)
  end

  def and_the_employer_form_feature_is_active
    FeatureFlags::FeatureFlag.activate(:employer_form)
  end

  def and_i_have_an_existing_referral
    @referral = Referral.create!
  end

  def when_i_visit_the_referral_summary
    visit edit_referral_path(@referral)
  end

  def and_i_dont_want_to_continue
    find(:button, text: "Delete your draft referral", visible: false).trigger(
      "click"
    )
  end

  def then_the_draft_referral_is_deleted
    expect { @referral.reload }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
