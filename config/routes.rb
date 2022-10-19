Rails.application.routes.draw do
  get "/start", to: "pages#start"
  get "/who", to: "reporting_as#new"
  post "/who", to: "reporting_as#create"
  get "/is-a-teacher", to: "is_teacher#new"
  post "/is-a-teacher", to: "is_teacher#create"
  get "/unsupervised-teaching", to: "unsupervised_teaching#new"
  post "/unsupervised-teaching", to: "unsupervised_teaching#create"
  get "/no-jurisdiction-unsupervised", to: "pages#no_jurisdiction_unsupervised"
  get "/teaching-in-england", to: "teaching_in_england#new"
  post "/teaching-in-england", to: "teaching_in_england#create"
  get "/no-jurisdiction", to: "pages#no_jurisdiction"
  get "/serious", to: "serious_misconduct#new"
  post "/serious", to: "serious_misconduct#create"
  get "/not-serious-misconduct", to: "pages#not_serious_misconduct"
  get "/you-should-know", to: "pages#you_should_know"
  get "/complete", to: "pages#complete"

  root to: redirect("/start")

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
