Rails.application.routes.draw do
  root to: redirect("/start")

  get "/confirmation", to: "pages#confirmation"
  get "/start", to: "pages#start"
  get "/who", to: "reporting_as#new"
  post "/who", to: "reporting_as#create"

  namespace :support_interface, path: "/support" do
    get "/", to: "support_interface#index"
    mount FeatureFlags::Engine => "/features"
  end

  scope via: :all do
    get "/404", to: "errors#not_found"
    get "/422", to: "errors#unprocessable_entity"
    get "/429", to: "errors#too_many_requests"
    get "/500", to: "errors#internal_server_error"
  end
end
