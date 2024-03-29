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
    },
    path: "",
    path_names: {
      sign_in: "manage/sign-in",
      sign_out: "manage/sign-out"
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

  constraints(-> { FeatureFlags::FeatureFlag.active?(:eligibility_screener) }) do
    get "/start", to: "pages#start"
    get "/used-service-before", to: "users/existing_registration#new"
    post "/used-service-before", to: "users/existing_registration#create"
    get "/referral-type", to: "eligibility_screener/referral_type#new"
    post "/referral-type", to: "eligibility_screener/referral_type#create"
    get "/is-a-teacher", to: "eligibility_screener/is_teacher#new"
    post "/is-a-teacher", to: "eligibility_screener/is_teacher#create"
    get "/complained-about-teacher", to: "public_eligibility_screener/complained_to_school#new"
    post "/complained-about-teacher", to: "public_eligibility_screener/complained_to_school#create"
    get "/wait-for-outcome", to: "public_eligibility_screener/awaiting_outcome#new"
    post "/wait-for-outcome", to: "public_eligibility_screener/awaiting_outcome#create"
    get "/consider-if-you-should-make-referral",
to: "public_eligibility_screener/consider_if_you_should_make_a_referral#new"
    post "/consider-if-you-should-make-a-referral",
to: "public_eligibility_screener/consider_if_you_should_make_a_referral#create"
    get "/public-is-a-teacher", to: "public_eligibility_screener/is_teacher#new"
    post "/public-is-a-teacher", to: "public_eligibility_screener/is_teacher#create"
    get "/make-complaint", to: "public_eligibility_screener/make_a_complaint#new"
    post "/make-complaint", to: "public_eligibility_screener/make_a_complaint#create"
    get "/what-allegation-involves", to: "public_eligibility_screener/allegation#new"
    post "/what-allegation-involves", to: "public_eligibility_screener/allegation#create"
    get "/public-teaching-in-england", to: "public_eligibility_screener/teaching_in_england#new"
    post "/public-teaching-in-england", to: "public_eligibility_screener/teaching_in_england#create"
    get "/no-jurisdiction-unsupervised", to: "pages#no_jurisdiction_unsupervised"
    get "/teaching-in-england", to: "eligibility_screener/teaching_in_england#new"
    post "/teaching-in-england", to: "eligibility_screener/teaching_in_england#create"
    get "/no-jurisdiction", to: "pages#no_jurisdiction"
    get "/serious-misconduct", to: "eligibility_screener/serious_misconduct#new"
    post "/serious-misconduct", to: "eligibility_screener/serious_misconduct#create"
    get "/not-serious-misconduct", to: "pages#not_serious_misconduct"
    get "/complaint-or-referral", to: "eligibility_screener/continue_with#new"
    post "/complaint-or-referral", to: "eligibility_screener/continue_with#create"
    get "/you-should-know", to: "pages#you_should_know"
    get "/make-a-complaint", to: "pages#make_a_complaint"
    get "/complete", to: "pages#complete"
  end

  constraints(-> { !FeatureFlags::FeatureFlag.active?(:eligibility_screener) }) do
    get "/",
        to:
          redirect(
            "https://www.gov.uk/government/publications/teacher-misconduct-referral-form",
            status: 307
          )
  end

  root to: "pages#start"

  resources :public_referrals, except: %i[index show], path: "public-referrals" do
    scope module: :public_referrals do
      constraints(RouteConstraints::PublicConstraint.new) do
        namespace :referrer_details, path: "referrer" do
          resource :name, only: %i[edit update], controller: :name
          resource :phone, only: %i[edit update], controller: :phone
          resource :check_answers, path: "check-answers", only: %i[edit update]
        end

        namespace :teacher_personal_details, path: "personal-details" do
          resource :name, only: %i[edit update], controller: :name
          resource :check_answers, path: "check-answers", only: %i[edit update]
        end

        resources :allegation_evidence, path: "evidence", only: [] do
          get "/delete", to: "allegation_evidence/check_answers#delete"
          delete "/", to: "allegation_evidence/check_answers#destroy", as: :destroy
        end
        namespace :allegation_evidence, path: "evidence" do
          resource :start, only: %i[edit update], controller: :start
          resource :upload, only: %i[edit update], controller: :upload
          resource :uploaded, only: %i[edit update], controller: :uploaded
          resource :check_answers,
                   path: "check-answers",
                   only: %i[edit update],
                   controller: :check_answers
        end

        namespace :allegation_details, path: "allegation" do
          resource :details, only: %i[edit update]
          resource :considerations, only: %i[edit update]
          resource :check_answers, path: "check-answers", only: %i[edit update]
        end

        namespace :teacher_role, path: "teacher-role" do
          resource :job_title, path: "job-title", only: %i[edit update], controller: :job_title
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
      end
    end
  end

  resources :referrals, except: %i[index show] do
    scope module: :referrals do
      constraints(RouteConstraints::EmployerConstraint.new) do
        namespace :teacher_personal_details, path: "personal-details" do
          resource :name, only: %i[edit update], controller: :name
          resource :age, only: %i[edit update], controller: :age
          resource :ni_number, only: %i[edit update], controller: :ni_number
          resource :trn, only: %i[edit update], controller: :trn
          resource :qts, only: %i[edit update], controller: :qts
          resource :check_answers, path: "check-answers", only: %i[edit update]
        end

        namespace :referrer_details, path: "referrer" do
          resource :name, only: %i[edit update], controller: :name
          resource :job_title, only: %i[edit update], path: "job-title", controller: :job_title
          resource :phone, only: %i[edit update], controller: :phone
          resource :check_answers, path: "check-answers", only: %i[edit update]
        end

        namespace :referrer_organisation, path: "organisation" do
          resource :address, only: %i[edit update], controller: :address
          resource :check_answers, path: "check-answers", only: %i[edit update]
        end

        namespace :teacher_contact_details, path: "contact-details" do
          resource :email, only: %i[edit update], controller: :email
          resource :telephone, only: %i[edit update], controller: :telephone
          resource :address_known, only: %i[edit update], controller: :address_known
          resource :address, only: %i[edit update], controller: :address
          resource :check_answers, path: "check-answers", only: %i[edit update]
        end

        namespace :allegation_previous_misconduct, path: "previous-misconduct" do
          resource :reported, only: %i[edit update], controller: :reported
          resource :detailed_account,
                   path: "detailed-account",
                   only: %i[edit update],
                   controller: :detailed_account
          resource :check_answers, path: "check-answers", only: %i[edit update]
        end

        namespace :allegation_details, path: "allegation" do
          resource :details, only: %i[edit update]
          resource :dbs, only: %i[edit update]
          resource :check_answers, path: "check-answers", only: %i[edit update]
        end

        namespace :teacher_role, path: "teacher-role" do
          resource :start_date, path: "start-date", only: %i[edit update], controller: :start_date
          resource :employment_status,
                   path: "employment-status",
                   only: %i[edit update],
                   controller: :employment_status
          resource :job_title, path: "job-title", only: %i[edit update], controller: :job_title
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
          resource :end_date, path: "end-date", only: %i[edit update], controller: :end_date
          resource :reason_leaving_role,
                   path: "reason-leaving-role",
                   only: %i[edit update],
                   controller: :reason_leaving_role
          resource :check_answers, path: "check-answers", only: %i[edit update]
        end

        resources :allegation_evidence, path: "evidence", only: [] do
          get "/delete", to: "allegation_evidence/check_answers#delete", as: :delete
          delete "/", to: "allegation_evidence/check_answers#destroy", as: :destroy
        end
        namespace :allegation_evidence, path: "evidence" do
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

  namespace :admin_interface, path: "/admin" do
    resources :feedback, only: [:index]
  end

  namespace :support_interface, path: "/support" do
    root to: redirect("/support/eligibility-checks")
    get "/performance", to: "performance#index"
    resources :staff, only: %i[index destroy] do
      get "/delete", on: :member, to: "staff#delete"
    end
    resources :staff_permissions, only: %i[edit update]
    resources :staff_invitations, only: %i[edit update]
    resources :test_users, only: %i[index create] do
      put "/authenticate", on: :member, to: "test_users#authenticate"
    end
    resources :validation_errors, only: %i[index] do
      get :history, on: :collection
    end

    devise_scope :staff do
      authenticate :staff do
        # Mount engines that require staff authentication here
        mount Sidekiq::Web, at: "sidekiq"
      end
    end

    get "/eligibility-checks", to: "eligibility_checks#index"
  end

  namespace :developer_interface, path: "/developer" do
    mount FeatureFlags::Engine => "/features"
  end

  namespace :manage_interface, path: "/manage" do
    resources :referrals, only: %i[index show]
  end

  get "malware-scan/:upload_id/pending", to: "malware_scan#pending", as: :malware_scan_pending
  get "malware-scan/:upload_id/suspect", to: "malware_scan#suspect", as: :malware_scan_suspect

  scope "/feedback" do
    get "/" => "feedbacks#new", :as => :feedbacks
    post "/" => "feedbacks#create"
    get "/confirmation" => "feedbacks#confirmation"
  end

  get "/accessibility", to: "static#accessibility"
  get "/cookies", to: "static#cookies"
  get "/privacy", to: "static#privacy"

  scope via: :all do
    get "/403", to: "errors#forbidden", as: :forbidden
    get "/404", to: "errors#not_found", as: :not_found
    get "/422", to: "errors#unprocessable_entity"
    get "/429", to: "errors#too_many_requests"
    get "/500", to: "errors#internal_server_error"
  end

  get "_sha", to: ->(_) { [200, {}, [ENV.fetch("GIT_SHA", "")]] }
end
