module SupportInterface
  class ValidationErrorsController < SupportInterfaceController
    def index
      @filter_form = FilterValidationForm.new
    end

    def history
      @form_object = params[:form_object]
      @attribute = params[:attribute]
      @errors =
      if @form_object.present?
        ValidationError.where(form_object: @form_object).order(created_at: :desc)
      else
        ValidationError.all
      end

      @errors_with_attribute_extracted =
        ValidationError.filter_on_attributes(@errors, @attribute)
    end

    def filter_params
      params.require(:filter_validation_form).permit(:form_object, :attribute)
    end
  end
end
