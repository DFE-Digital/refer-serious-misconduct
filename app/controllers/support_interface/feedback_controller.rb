# frozen_string_literal: true

module SupportInterface
  class FeedbackController < SupportInterfaceController
    def index
      @feedbacks = Feedback.all
    end
  end
end
