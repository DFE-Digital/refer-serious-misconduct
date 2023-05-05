module EligibilityScreener
  class RecentlyComplainedController < EligibilityScreenerController
    def new
      @recently_complained_form =
        EligibilityScreener::RecentlyComplainedForm.new(eligibility_check:)
    end

    def create
      @recently_complained_form =
        EligibilityScreener::RecentlyComplainedForm.new(
          recently_complained_form_params.merge(eligibility_check:)
        )

      if @recently_complained_form.save
        if eligibility_check.recently_complained?
          redirect_to(have_recently_complained_path)
        else
          redirect_to_next_question
        end
      else
        render :new
      end
    end

    private

    def recently_complained_form_params
      params.require(:eligibility_screener_recently_complained_form).permit(:recently_complained)
    end
  end
end
