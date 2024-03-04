module AdminInterface
  class FeedbackController < AdminInterfaceController
    def index
      @feedbacks = Feedback.order(id: :desc)
    end
  end
end
