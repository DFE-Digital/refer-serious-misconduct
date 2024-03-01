module AdminInterface
  class FeedbackController < AdminInterfaceController
    def index
      @feedbacks = Feedback.all
    end
  end
end
