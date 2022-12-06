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
      { path: who_path, needs_answer: reporting_as_needs_answer? },
      {
        path: have_you_complained_path,
        needs_answer: complained_needs_answer?
      },
      { path: is_a_teacher_path, needs_answer: is_a_teacher_needs_answer? },
      {
        path: unsupervised_teaching_path,
        needs_answer: unsupervised_teaching_needs_answer?
      },
      {
        path: teaching_in_england_path,
        needs_answer: teaching_in_england_needs_answer?
      },
      { path: serious_path, needs_answer: serious_misconduct_needs_answer? }
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

    !previous_question[:needs_answer]
  end

  def reporting_as_needs_answer?
    eligibility_check.reporting_as.nil?
  end

  def complained_needs_answer?
    return false if eligibility_check.reporting_as_employer?

    eligibility_check.complained.nil?
  end

  def unsupervised_teaching_needs_answer?
    return false if eligibility_check.is_teacher?

    eligibility_check.unsupervised_teaching.nil?
  end

  def is_a_teacher_needs_answer?
    eligibility_check.is_teacher.nil?
  end

  def teaching_in_england_needs_answer?
    eligibility_check.teaching_in_england.nil?
  end

  def serious_misconduct_needs_answer?
    eligibility_check.serious_misconduct.nil?
  end
end
