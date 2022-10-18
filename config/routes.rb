Rails.application.routes.draw do
  root to: redirect("/start")

  get "/start", to: "pages#start"
  get "/who", to: "reporting_as#new"
  post "/who", to: "reporting_as#create"
  get "/you-should-know", to: "pages#you_should_know"
  get "/serious", to: "serious_misconduct#new"
  post "/serious", to: "serious_misconduct#create"
  get "/not-serious-misconduct", to: "pages#not_serious_misconduct"
  get "/complete", to: "pages#complete"

  namespace :support_interface, path: "/support" do
    resources :eligibility_checks, only: [:index]
    mount FeatureFlags::Engine => "/features"

    root to: redirect("/support/eligibility_checks")
  end

  scope via: :all do
    get "/404", to: "errors#not_found"
    get "/422", to: "errors#unprocessable_entity"
    get "/429", to: "errors#too_many_requests"
    get "/500", to: "errors#internal_server_error"
  end
end
