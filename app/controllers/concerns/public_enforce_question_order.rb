# frozen_string_literal: true
module PublicEnforceQuestionOrder
  extend ActiveSupport::Concern

  included { before_action :redirect_to_correct_question }

  private

  def redirect_to_correct_question
    redirect_to(start_url) and return if redirect_to_start_page?

    return if all_previous_question_answered? || request.path == next_question_path

    redirect_to_next_question
  end

  def redirect_to_next_question
    redirect_to next_question_path
  end

  def redirect_to_start_page?
    unsaved_eligibility_check_after_start? || !all_previous_question_answered?
  end

  def unsaved_eligibility_check_after_start?
    (eligibility_check.nil? || eligibility_check.new_record?) &&
      request.path != questions.first[:path]
  end

  def questions
    [
      { path: referral_type_path, needs_answer: true, answered: referral_type_answered? },
      { path: complained_about_teacher_path, needs_answer: true, answered: complained_to_school_answered? },
      complained_to_school_question,
      {
        path: what_allegation_involves_path,
        needs_answer: complaint_status_received?,
        answered: serious_misconduct_answered?
      },
      { path: consider_if_you_should_make_referral_path, needs_answer: is_allegation_none_of_the_options?,
answered: is_allegation_none_of_the_options? },

      { path: public_is_a_teacher_path, needs_answer: true, answered: is_a_teacher_answered? },
      {
        path: public_unsupervised_teaching_path,
        needs_answer: !eligibility_check.is_teacher?,
        answered: unsupervised_teaching_answered?
      },
      {
        path: public_teaching_in_england_path,
        needs_answer: true,
        answered: teaching_in_england_answered?
      },
    ]
  end

  def next_question_path
    next_question&.dig(:path) || you_should_know_path
  end

  def all_previous_question_answered?
    questions[0...requested_question_index].all? { |q| q[:answered] || !q[:needs_answer] }
  end

  def requested_question_index
    questions.find_index { |q| q[:path] == request.path }
  end

  def next_question
    questions[(requested_question_index + 1)..].find { |q| q[:needs_answer] }
  end

  def previous_question
    questions[..(requested_question_index - 1)].reverse.find { |q| q[:needs_answer] }
  end

  def referral_type_answered?
    !eligibility_check.reporting_as.nil?
  end

  def unsupervised_teaching_answered?
    !eligibility_check.unsupervised_teaching.nil?
  end

  def is_allegation_none_of_the_options?
    eligibility_check.serious_misconduct == "[\"none\"]"
  end

  def is_a_teacher_answered?
    !eligibility_check.is_teacher.nil?
  end

  def complained_to_school_answered?
    !eligibility_check.complained.nil?
  end

  def teaching_in_england_answered?
    !eligibility_check.teaching_in_england.nil?
  end

  def serious_misconduct_answered?
    !eligibility_check.serious_misconduct.nil?
  end

  def continue_with_answered?
    !eligibility_check.continue_with.nil?
  end

  def complained_to_school_question
    if eligibility_check.complaint_status == "received"
      { path: what_allegation_involves_path, needs_answer: true, answered: complained_to_school_answered? }
    elsif eligibility_check.complaint_status == "awaiting"
      { path: wait_for_outcome_path , needs_answer: true, answered: complained_to_school_answered? }
    elsif eligibility_check.complaint_status == "no" && eligibility_check.complained == false
      { path: make_complaint_path , needs_answer: true, answered: complained_to_school_answered? }
    end
  end

  def complaint_status_received?
    eligibility_check.complaint_status == "no"
  end
end