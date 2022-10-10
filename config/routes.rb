Rails.application.routes.draw do
  root to: "pages#home"

  namespace :support_interface, path: "/support" do
    get "/", to: "support_interface#index"
  end

  mount FeatureFlags::Engine => "/feature_flags" if Rails.env.development?

  scope via: :all do
    get "/404", to: "errors#not_found"
    get "/422", to: "errors#unprocessable_entity"
    get "/429", to: "errors#too_many_requests"
    get "/500", to: "errors#internal_server_error"
  end
end
