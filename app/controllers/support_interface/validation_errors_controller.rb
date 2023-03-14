module SupportInterface
  class ValidationErrorsController < SupportInterfaceController
    def index
      @grouped_counts =
        ValidationError.group(:form_object).order("count_all DESC").count
      @grouped_column_error_counts =
        ValidationError.list_of_distinct_errors_with_count
    end
  end
end
