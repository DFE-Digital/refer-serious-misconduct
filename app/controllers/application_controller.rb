class ApplicationController < ActionController::Base
  default_form_builder(GOVUKDesignSystemFormBuilder::FormBuilder)

  http_basic_authenticate_with name: ENV.fetch("SUPPORT_USERNAME", nil),
                               password: ENV.fetch("SUPPORT_PASSWORD", nil)
end
