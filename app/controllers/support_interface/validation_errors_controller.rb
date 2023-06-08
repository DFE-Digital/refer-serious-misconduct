module SupportInterface
  class ValidationErrorsController < SupportInterfaceController
    def index
      @grouped_counts = ValidationError.group(:form_object).order("count_all DESC").count
      @grouped_column_error_counts = ValidationError.list_of_distinct_errors_with_count
    end

    def history
      @form_object = params[:form_object]
      @attribute = params[:attribute]

      @errors = ValidationError.where(form_object: @form_object).order(created_at: :desc)

      @errors_with_attribute_extracted =
        ValidationError.extract_attribute_from_errors(@errors, @attribute)
    end
  end
end
