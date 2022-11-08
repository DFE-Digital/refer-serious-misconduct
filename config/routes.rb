require "sidekiq/web"

Rails.application.routes.draw do
  devise_for(
    :staff,
    controllers: {
      confirmations: "staff/confirmations",
      invitations: "staff/invitations",
      passwords: "staff/passwords",
      sessions: "staff/sessions",
      unlocks: "staff/unlocks"
    }
  )
  devise_scope :staff do
    get "/staff/sign_out", to: "staff/sessions#destroy"
  end

  devise_for(:user)
  devise_scope :user do
    get "/users/session/new", to: "users/sessions#new", as: "new_user_session"
    post "/users/session", to: "users/sessions#create", as: "user_session"
    get "/users/otp/new", to: "users/otp#new", as: "new_user_otp"
    post "/users/otp", to: "users/otp#create", as: "user_otp"

    get "/users/sign_out", to: "users/sessions#destroy"
  end

  get "/start", to: "pages#start"
  get "/who", to: "reporting_as#new"
  post "/who", to: "reporting_as#create"
  get "/have-you-complained", to: "have_complained#new"
  post "/have-you-complained", to: "have_complained#create"
  get "/no-complaint", to: "pages#no_complaint"
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

  resources :referrals, except: %i[index show] do
    get "/delete", to: "referrals#delete", on: :member
    get "/deleted", to: "referrals#deleted", on: :collection

    resource :referrer, only: %i[show update], controller: "referrals/referrers"
    resource :referrer_details,
             only: %i[show],
             path: "referrer-details",
             controller: "referrals/referrer_details"

    resource :referrer_job_title,
             only: %i[edit update],
             path: "referrer-job-title",
             controller: "referrals/referrer_job_title"

    resource :referrer_phone,
             controller: "referrals/referrer_phone",
             only: %i[edit update],
             path: "referrer-phone"

    resource :referrer_name,
             only: %i[edit update],
             path: "referrer-name",
             controller: "referrals/referrer_name"
  end

  namespace :referrals do
    get "/:referral_id/personal-details/name",
        to: "personal_details/name#edit",
        as: "edit_personal_details_name"
    put "/:referral_id/personal-details/name",
        to: "personal_details/name#update",
        as: "update_personal_details_name"
    get "/:referral_id/personal-details/age",
        to: "personal_details/age#edit",
        as: "edit_personal_details_age"
    put "/:referral_id/personal-details/age",
        to: "personal_details/age#update",
        as: "update_personal_details_age"
    get "/:referral_id/personal-details/trn",
        to: "personal_details/trn#edit",
        as: "edit_personal_details_trn"
    put "/:referral_id/personal-details/trn",
        to: "personal_details/trn#update",
        as: "update_personal_details_trn"
    get "/:referral_id/personal-details/qts",
        to: "personal_details/qts#edit",
        as: "edit_personal_details_qts"
    put "/:referral_id/personal-details/qts",
        to: "personal_details/qts#update",
        as: "update_personal_details_qts"
    get "/:referral_id/personal-details/confirm",
        to: "personal_details/confirm#edit",
        as: "edit_personal_details_confirm"
    put "/:referral_id/personal-details/confirm",
        to: "personal_details/confirm#update",
        as: "update_personal_details_confirm"

    get "/:id/contact-details/email",
        to: "contact_details/email#edit",
        as: "edit_contact_details_email"
    put "/:id/contact-details/email",
        to: "contact_details/email#update",
        as: "update_contact_details_email"
    get "/:id/contact-details/telephone",
        to: "contact_details/telephone#edit",
        as: "edit_contact_details_telephone"
    put "/:id/contact-details/telephone",
        to: "contact_details/telephone#update",
        as: "update_contact_details_telephone"
    get "/:id/contact-details/address",
        to: "contact_details/address#edit",
        as: "edit_contact_details_address"
    put "/:id/contact-details/address",
        to: "contact_details/address#update",
        as: "update_contact_details_address"
  end

  get "/performance", to: "performance#index"

  namespace :support_interface, path: "/support" do
    mount FeatureFlags::Engine => "/features"

    root to: redirect("/support/eligibility-checks")

    resources :staff, only: %i[index]

    devise_scope :staff do
      authenticate :staff do
        # Mount engines that require staff authentication here
        mount Sidekiq::Web, at: "sidekiq"
      end
    end

    get "/eligibility-checks", to: "eligibility_checks#index"
  end

  get "/accessibility", to: "static#accessibility"
  get "/cookies", to: "static#cookies"
  get "/privacy", to: "static#privacy"

  scope via: :all do
    get "/404", to: "errors#not_found"
    get "/422", to: "errors#unprocessable_entity"
    get "/429", to: "errors#too_many_requests"
    get "/500", to: "errors#internal_server_error"
  end

  get "_sha", to: ->(_) { [200, {}, [ENV.fetch("GIT_SHA", "")]] }
end
