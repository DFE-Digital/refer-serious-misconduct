# frozen_string_literal: true
module EnforceQuestionOrder
  extend ActiveSupport::Concern

  included { before_action :redirect_to_next_question }

  def redirect_to_next_question
    redirect_to(start_url) and return if start_page_is_required?
    return if all_questions_answered?
    return if previous_question_answered?

    redirect_to next_question_path if request.path != next_question_path
  end

  def next_question
    session[:eligibility_check_id] ||= eligibility_check.reload.id

    redirect_to next_question_path
  end

  private

  def eligibility_check
    @eligibility_check ||=
      EligibilityCheck.find_or_initialize_by(id: session[:eligibility_check_id])
  end

  def start_page_is_required?
    (eligibility_check.nil? || eligibility_check.new_record?) &&
      request.path != who_path
  end

  def questions
    [
      { path: who_path, needs_answer: ask_for_reporting_as? },
      {
        path: unsupervised_teaching_path,
        needs_answer: ask_for_unsupervised_teaching?
      },
      {
        path: no_jurisdiction_unsupervised_path,
        needs_answer: ask_for_no_jurisdiction_unsupervised?
      },
      {
        path: teaching_in_england_path,
        needs_answer: ask_for_teaching_in_england?
      },
      { path: no_jurisdiction_path, needs_answer: ask_for_no_jurisdiction? },
      { path: serious_path, needs_answer: ask_for_serious_misconduct? },
      { path: you_should_know_path, needs_answer: false },
      {
        path: not_serious_misconduct_path,
        needs_answer: ask_for_not_serious_misconduct?
      }
    ]
  end

  def next_question_path
    questions.each { |q| return q[:path] if q[:needs_answer] }

    you_should_know_path
  end

  def all_questions_answered?
    questions.none? { |q| q[:needs_answer] }
  end

  def previous_question_answered?
    requested_question_index =
      questions.find_index { |q| q[:path] == request.path }

    path_is_not_a_question = requested_question_index.nil?
    return false if path_is_not_a_question

    is_first_question = requested_question_index.zero?
    return true if is_first_question

    previous_question = questions[requested_question_index - 1]

    previous_question[:needs_answer] == false
  end

  def ask_for_reporting_as?
    eligibility_check.reporting_as.nil?
  end

  def ask_for_unsupervised_teaching?
    eligibility_check.unsupervised_teaching.nil?
  end

  def ask_for_no_jurisdiction_unsupervised?
    !eligibility_check.unsupervised_teaching?
  end

  def ask_for_teaching_in_england?
    return false unless eligibility_check.unsupervised_teaching?

    eligibility_check.teaching_in_england.nil?
  end

  def ask_for_no_jurisdiction?
    !eligibility_check.teaching_in_england?
  end

  def ask_for_serious_misconduct?
    return false unless eligibility_check.teaching_in_england?

    eligibility_check.serious_misconduct.nil?
  end

  def ask_for_not_serious_misconduct?
    !eligibility_check.serious_misconduct?
  end

  def ask_for_you_should_know?
    eligibility_check.serious_misconduct?
  end
end
