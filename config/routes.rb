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
    get "/users/otp/retry/:error",
        to: "users/otp#retry",
        as: "retry_user_sign_in",
        constraints: {
          error: /(expired)|(exhausted)/
        }

    get "/users/sign_out", to: "users/sessions#destroy"
  end

  constraints(
    -> { FeatureFlags::FeatureFlag.active?(:eligibility_screener) }
  ) do
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
    get "/no-jurisdiction-unsupervised",
        to: "pages#no_jurisdiction_unsupervised"
    get "/teaching-in-england", to: "teaching_in_england#new"
    post "/teaching-in-england", to: "teaching_in_england#create"
    get "/no-jurisdiction", to: "pages#no_jurisdiction"
    get "/serious", to: "serious_misconduct#new"
    post "/serious", to: "serious_misconduct#create"
    get "/not-serious-misconduct", to: "pages#not_serious_misconduct"
    get "/you-should-know", to: "pages#you_should_know"
    get "/complete", to: "pages#complete"
  end

  constraints(
    -> { !FeatureFlags::FeatureFlag.active?(:eligibility_screener) }
  ) do
    get "/start",
        to:
          redirect(
            "https://www.gov.uk/government/publications/teacher-misconduct-referral-form",
            status: 307
          )
  end

  root to: redirect("/start")

  resources :referrals, except: %i[index] do
    get "/delete", to: "referrals#delete", on: :member
    get "/deleted", to: "referrals#deleted", on: :collection

    resource :confirmation, only: %i[show], controller: "referrals/confirmation"

    resource :declaration,
             only: %i[show create],
             controller: "referrals/declaration"

    resource :organisation,
             only: %i[show update],
             controller: "referrals/organisation"

    resource :organisation_name,
             only: %i[edit update],
             controller: "referrals/organisation_name"

    resource :organisation_address,
             only: %i[edit update],
             controller: "referrals/organisation_address"

    resource :previous_misconduct,
             only: %i[show update],
             controller: "referrals/previous_misconduct"

    resource :previous_misconduct_detailed_account,
             only: %i[edit update],
             controller: "referrals/previous_misconduct_detailed_account"

    resource :previous_misconduct_reported,
             only: %i[edit update],
             controller: "referrals/previous_misconduct_reported"

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

    resource :review, only: %i[show], controller: "referrals/review"

    scope module: "referrals" do
      namespace :personal_details, path: "personal-details" do
        resource :name, only: %i[edit update], controller: :name
        resource :age, only: %i[edit update], controller: :age
        resource :trn, only: %i[edit update], controller: :trn
        resource :qts, only: %i[edit update], controller: :qts
        resource :check_answers, path: "check-answers", only: %i[edit update]
      end

      namespace :contact_details, path: "contact-details" do
        resource :email, only: %i[edit update], controller: :email
        resource :telephone, only: %i[edit update], controller: :telephone
        resource :address, only: %i[edit update], controller: :address
        resource :check_answers, path: "check-answers", only: %i[edit update]
      end

      namespace :allegation do
        resource :details, only: %i[edit update]
        resource :dbs, only: %i[edit update]
        resource :check_answers, path: "check-answers", only: %i[edit update]
      end
    end
  end

  namespace :referrals do
    get "/:referral_id/teacher-role/start-date",
        to: "teacher_role/start_date#edit",
        as: "edit_teacher_role_start_date"
    put "/:referral_id/teacher-role/start-date",
        to: "teacher_role/start_date#update",
        as: "update_teacher_role_start_date"
    get "/:referral_id/teacher-role/employment-status",
        to: "teacher_role/employment_status#edit",
        as: "edit_teacher_role_employment_status"
    put "/:referral_id/teacher-role/employment-status",
        to: "teacher_role/employment_status#update",
        as: "update_teacher_role_employment_status"
    get "/:referral_id/teacher-role/job-title",
        to: "teacher_role/job_title#edit",
        as: "edit_teacher_role_job_title"
    put "/:referral_id/teacher-role/job-title",
        to: "teacher_role/job_title#update",
        as: "update_teacher_role_job_title"
    get "/:referral_id/teacher-role/same-organisation",
        to: "teacher_role/same_organisation#edit",
        as: "edit_teacher_role_same_organisation"
    put "/:referral_id/teacher-role/same-organisation",
        to: "teacher_role/same_organisation#update",
        as: "update_teacher_role_same_organisation"
    get "/:referral_id/teacher-role/duties",
        to: "teacher_role/duties#edit",
        as: "edit_teacher_role_duties"
    put "/:referral_id/teacher-role/duties",
        to: "teacher_role/duties#update",
        as: "update_teacher_role_duties"
    get "/:referral_id/teacher-role/teaching-somewhere-else",
        to: "teacher_role/teaching_somewhere_else#edit",
        as: "edit_teacher_role_teaching_somewhere_else"
    put "/:referral_id/teacher-role/teaching-somewhere-else",
        to: "teacher_role/teaching_somewhere_else#update",
        as: "update_teacher_role_teaching_somewhere_else"
    get "/:referral_id/teacher-role/teaching-location",
        to: "teacher_role/teaching_location#edit",
        as: "edit_teacher_role_teaching_location"
    put "/:referral_id/teacher-role/teaching-location",
        to: "teacher_role/teaching_location#update",
        as: "update_teacher_role_teaching_location"
    get "/:referral_id/teacher-role/check-answers",
        to: "teacher_role/check_answers#edit",
        as: "edit_teacher_role_check_answers"
    put "/:referral_id/teacher-role/check-answers",
        to: "teacher_role/check_answers#update",
        as: "update_teacher_role_check_answers"

    get "/:referral_id/evidence/start",
        to: "evidence/start#edit",
        as: "edit_evidence_start"
    put "/:referral_id/evidence/start",
        to: "evidence/start#update",
        as: "update_evidence_start"
    get "/:referral_id/evidence/upload",
        to: "evidence/upload#edit",
        as: "edit_evidence_upload"
    get "/:referral_id/evidence/uploaded",
        to: "evidence/upload#show",
        as: "evidence_uploaded"
    put "/:referral_id/evidence/upload",
        to: "evidence/upload#update",
        as: "update_evidence_upload"
    get "/:referral_id/evidence/:evidence_id/categories",
        to: "evidence/categories#edit",
        as: "edit_evidence_categories"
    put "/:referral_id/evidence/:evidence_id/categories",
        to: "evidence/categories#update",
        as: "update_evidence_categories"
    get "/:referral_id/evidence/check-answers",
        to: "evidence/check_answers#edit",
        as: "edit_evidence_check_answers"
    put "/:referral_id/evidence/check-answers",
        to: "evidence/check_answers#update",
        as: "update_evidence_check_answers"
    get "/:referral_id/evidence/:evidence_id/delete",
        to: "evidence/check_answers#delete",
        as: "delete_evidence"
    delete "/:referral_id/evidence/:evidence_id",
           to: "evidence/check_answers#destroy",
           as: "destroy_evidence"
  end

  get "/performance", to: "performance#index"

  namespace :support_interface, path: "/support" do
    root to: redirect("/support/eligibility-checks")
    resources :staff, only: %i[index]
    resources :test_users, only: %i[index create] do
      put "/authenticate", on: :member, to: "test_users#authenticate"
    end

    mount FeatureFlags::Engine => "/features"

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
