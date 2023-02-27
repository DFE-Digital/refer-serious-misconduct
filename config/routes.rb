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
    get "/manage/sign-out", to: "staff/sessions#destroy"
    get "/manage/sign-in", to: "staff/sessions#new"
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

    namespace :users do
      resources :referrals, only: %i[index show]
    end
  end

  constraints(
    -> { FeatureFlags::FeatureFlag.active?(:eligibility_screener) }
  ) do
    get "/start", to: "pages#start"
    get "/users/registrations/exists", to: "users/existing_registration#new"
    post "/users/registrations/exists", to: "users/existing_registration#create"
    get "/referral-type", to: "referral_type#new"
    post "/referral-type", to: "referral_type#create"
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
    get "/serious-misconduct", to: "serious_misconduct#new"
    post "/serious-misconduct", to: "serious_misconduct#create"
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

  resources :public_referrals,
            except: %i[index show],
            path: "public-referrals" do
    scope module: :public_referrals do
      constraints(RouteConstraints::PublicConstraint.new) do
        namespace :personal_details, path: "personal-details" do
          resource :name, only: %i[edit update], controller: :name
          resource :check_answers, path: "check-answers", only: %i[edit update]
        end

        resources :evidence, only: [] do
          get "/delete", to: "evidence/check_answers#delete"
          delete "/", to: "evidence/check_answers#destroy", as: :destroy
        end
        namespace :evidence do
          resource :start, only: %i[edit update], controller: :start
          resource :upload, only: %i[edit update], controller: :upload
          resource :uploaded, only: %i[edit update], controller: :uploaded
          resource :check_answers,
                   only: %i[edit update],
                   controller: :check_answers
        end

        namespace :allegation do
          resource :details, only: %i[edit update]
          resource :considerations, only: %i[edit update]
          resource :check_answers, path: "check-answers", only: %i[edit update]
        end

        namespace :teacher_role, path: "teacher-role" do
          resource :job_title,
                   path: "job-title",
                   only: %i[edit update],
                   controller: :job_title
          resource :duties, only: %i[edit update]
          resource :organisation_address_known,
                   path: "organisation-address-known",
                   only: %i[edit update],
                   controller: :organisation_address_known
          resource :organisation_address,
                   path: "organisation-address",
                   only: %i[edit update],
                   controller: :organisation_address
          resource :check_answers, path: "check-answers", only: %i[edit update]
        end

        resource :review, only: %i[show update], controller: :review
        resource :confirmation, only: %i[show], controller: :confirmation

        resource :referrer, only: %i[show update]
        get "/personal-details", to: "referrers#personal_details"

        resource :referrer_name,
          only: %i[edit update],
          path: "referrer-name",
          controller: :referrer_name

        resource :referrer_phone,
          only: %i[edit update],
          path: "referrer-phone",
          controller: :referrer_phone
      end
    end
  end

  resources :referrals, except: %i[index show] do
    scope module: :referrals do
      constraints(RouteConstraints::EmployerConstraint.new) do
        namespace :personal_details, path: "personal-details" do
          resource :name, only: %i[edit update], controller: :name
          resource :age, only: %i[edit update], controller: :age
          resource :ni_number, only: %i[edit update], controller: :ni_number
          resource :trn, only: %i[edit update], controller: :trn
          resource :qts, only: %i[edit update], controller: :qts
          resource :check_answers, path: "check-answers", only: %i[edit update]
        end

        resource :referrer, only: %i[show update]
        resource :referrer_details, only: %i[show], path: "referrer-details"
        resource :referrer_name,
                 only: %i[edit update],
                 path: "referrer-name",
                 controller: :referrer_name
        resource :referrer_job_title,
                 only: %i[edit update],
                 path: "referrer-job-title",
                 controller: :referrer_job_title
        resource :referrer_phone,
                 only: %i[edit update],
                 path: "referrer-phone",
                 controller: :referrer_phone

        namespace :contact_details, path: "contact-details" do
          resource :email, only: %i[edit update], controller: :email
          resource :telephone, only: %i[edit update], controller: :telephone
          resource :address_known,
                   only: %i[edit update],
                   controller: :address_known
          resource :address, only: %i[edit update], controller: :address
          resource :check_answers, path: "check-answers", only: %i[edit update]
        end

        resource :organisation, only: %i[show update], controller: :organisation
        resource :organisation_name,
                 only: %i[edit update],
                 controller: :organisation_name
        resource :organisation_address,
                 only: %i[edit update],
                 controller: :organisation_address

        namespace :previous_misconduct, path: "previous-misconduct" do
          resource :reported, only: %i[edit update], controller: :reported
          resource :detailed_account,
                   path: "detailed-account",
                   only: %i[edit update],
                   controller: :detailed_account
          resource :check_answers, path: "check-answers", only: %i[edit update]
        end

        namespace :allegation do
          resource :details, only: %i[edit update]
          resource :dbs, only: %i[edit update]
          resource :check_answers, path: "check-answers", only: %i[edit update]
        end

        namespace :teacher_role, path: "teacher-role" do
          resource :start_date,
                   path: "start-date",
                   only: %i[edit update],
                   controller: :start_date
          resource :employment_status,
                   path: "employment-status",
                   only: %i[edit update],
                   controller: :employment_status
          resource :job_title,
                   path: "job-title",
                   only: %i[edit update],
                   controller: :job_title
          resource :same_organisation,
                   path: "same-organisation",
                   only: %i[edit update],
                   controller: :same_organisation
          resource :duties, only: %i[edit update]
          resource :working_somewhere_else,
                   path: "working-somewhere-else",
                   only: %i[edit update],
                   controller: :working_somewhere_else
          resource :work_location_known,
                   path: "work-location-known",
                   only: %i[edit update],
                   controller: :work_location_known
          resource :work_location,
                   path: "work-location",
                   only: %i[edit update],
                   controller: :work_location
          resource :organisation_address_known,
                   path: "organisation-address-known",
                   only: %i[edit update],
                   controller: :organisation_address_known
          resource :organisation_address,
                   path: "organisation-address",
                   only: %i[edit update],
                   controller: :organisation_address
          resource :end_date,
                   path: "end-date",
                   only: %i[edit update],
                   controller: :end_date
          resource :reason_leaving_role,
                   path: "reason-leaving-role",
                   only: %i[edit update],
                   controller: :reason_leaving_role
          resource :check_answers, path: "check-answers", only: %i[edit update]
        end

        resources :evidence, only: [] do
          get "/delete", to: "evidence/check_answers#delete", as: :delete
          delete "/", to: "evidence/check_answers#destroy", as: :destroy
        end
        namespace :evidence do
          resource :start, only: %i[edit update], controller: :start
          resource :upload, only: %i[edit update], controller: :upload
          resource :uploaded, only: %i[edit update], controller: :uploaded
          resource :check_answers, path: "check-answers", only: %i[edit update]
        end

        resource :confirmation, only: %i[show], controller: :confirmation
        resource :review, only: %i[show update], controller: :review
      end
    end
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

  namespace :manage_interface, path: "/manage" do
    resources :referrals, only: %i[index show]
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
