module FeedbackHelper
  def satisfaction_rating_options(ratings)
    ratings.map { |rating| OpenStruct.new(label: rating.humanize, value: rating) }
  end
end
