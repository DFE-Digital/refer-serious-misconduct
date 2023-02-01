class ReferralForm
  include Rails.application.routes.url_helpers
  include ActiveModel::Model
  include ReferralHelper

  attr_accessor :referral

  # TODO: Replace these with something reading from :referral model fields
  ReferralSection = Struct.new(:number, :label, :items)
  ReferralSectionItem = Struct.new(:label, :path, :status)

  validate :sections_valid

  def save
    valid?
  end

  def sections
    [
      about_you_section,
      about_the_person_you_are_referring_section,
      the_allegation_section
    ]
  end

  private

  def sections_valid
    unless sections.map(&:items).flatten.map(&:status).uniq == [:completed]
      errors.add(:base, "Please complete all sections of the referral")
    end
  end

  def about_you_section
    ReferralSection
      .new(1, I18n.t("referral_form.about_you"))
      .tap do |section|
        section.items = [
          ReferralSectionItem.new(
            I18n.t("referral_form.your_details"),
            about_you_section_path,
            referral.referrer_status
          )
        ]

        if referral.from_employer?
          section.items.append(
            ReferralSectionItem.new(
              I18n.t("referral_form.your_organisation"),
              about_your_organisation_section_path,
              referral.organisation_status
            )
          )
        end
      end
  end

  def about_you_section_path
    if referral.referrer.present?
      return polymorphic_path([referral.routing_scope, referral, :referrer])
    end

    polymorphic_path([:edit, referral.routing_scope, referral, :referrer_name])
  end

  def about_the_person_you_are_referring_section
    ReferralSection
      .new(2, I18n.t("referral_form.about_the_person_you_are_referring"))
      .tap do |section|
        section.items = [
          ReferralSectionItem.new(
            I18n.t("referral_form.personal_details"),
            personal_details_section_path,
            section_status(:personal_details_complete)
          )
        ]

        if referral.from_employer?
          section.items.append(
            ReferralSectionItem.new(
              I18n.t("referral_form.contact_details"),
              contact_details_section_path,
              section_status(:contact_details_complete)
            )
          )
        end

        section.items.append(
          ReferralSectionItem.new(
            I18n.t("referral_form.about_their_role"),
            about_their_role_section_path,
            section_status(:teacher_role_complete)
          )
        )
      end
  end

  def the_allegation_section
    ReferralSection
      .new(3, I18n.t("referral_form.the_allegation"))
      .tap do |section|
        section.items = [
          ReferralSectionItem.new(
            I18n.t("referral_form.details_of_the_allegation"),
            polymorphic_path(
              [:edit, referral.routing_scope, referral, :allegation_details]
            ),
            section_status(:allegation_details_complete)
          )
        ]

        if referral.from_employer?
          section.items.append(
            ReferralSectionItem.new(
              I18n.t("referral_form.previous_allegations"),
              polymorphic_path(
                [
                  :edit,
                  referral.routing_scope,
                  referral,
                  :previous_misconduct_reported
                ]
              ),
              referral.previous_misconduct_status
            )
          )
        end

        section.items.append(
          ReferralSectionItem.new(
            I18n.t("referral_form.evidence_and_supporting_information"),
            path_for_section_status(
              section_status(:evidence_details_complete),
              polymorphic_path(
                [:edit, referral.routing_scope, referral, :evidence_start]
              ),
              polymorphic_path(
                [
                  :edit,
                  referral.routing_scope,
                  referral,
                  :evidence_check_answers
                ]
              )
            ),
            section_status(:evidence_details_complete)
          )
        )
      end
  end

  def section_status(section_complete_method)
    status = referral.send(section_complete_method)
    return :not_started_yet if status.nil?

    status ? :completed : :incomplete
  end

  def path_for_section_status(status, start_path, check_answers_path)
    return start_path if status == :not_started_yet

    check_answers_path
  end

  def about_your_organisation_section_path
    if referral.organisation.present?
      return polymorphic_path([referral.routing_scope, referral, :organisation])
    end

    polymorphic_path(
      [:edit, referral.routing_scope, referral, :organisation_address]
    )
  end

  def personal_details_section_path
    if referral.personal_details_complete.nil?
      return(
        polymorphic_path(
          [:edit, referral.routing_scope, referral, :personal_details_name]
        )
      )
    end

    polymorphic_path(
      [
        :edit,
        referral.routing_scope,
        referral,
        :personal_details,
        :check_answers
      ]
    )
  end

  def contact_details_section_path
    if referral.contact_details_complete.nil?
      return(
        polymorphic_path(
          [:edit, referral.routing_scope, referral, :contact_details_email]
        )
      )
    end

    polymorphic_path(
      [
        :edit,
        referral.routing_scope,
        referral,
        :contact_details,
        :check_answers
      ]
    )
  end

  def about_their_role_section_path
    if referral.teacher_role_complete.nil?
      return(
        polymorphic_path(
          [:edit, referral.routing_scope, referral, :teacher_role, :job_title]
        )
      )
    end

    polymorphic_path(
      [:edit, referral.routing_scope, referral, :teacher_role, :check_answers]
    )
  end
end
