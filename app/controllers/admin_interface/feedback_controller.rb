# frozen_string_literal: true

module AdminInterface
  class FeedbackController < AdminInterfaceController
    def index
      @feedbacks = Feedback.all
    end
  end
end
