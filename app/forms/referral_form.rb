class ReferralForm
  include Rails.application.routes.url_helpers
  include ActiveModel::Model
  include ReferralHelper
  include ValidationTracking

  attr_accessor :referral

  # TODO: Replace these with something reading from :referral model fields
  ReferralSection = Struct.new(:number, :label, :items)
  ReferralSectionItem = Struct.new(:label, :path, :status)

  validate :sections_valid

  def save
    valid?
  end

  def submit
    return false if !valid? || referral.submitted?

    referral.submit
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
      errors.add(:base, :all_sections_complete)
    end
  end

  def about_you_section
    ReferralSection
      .new(1, I18n.t("referral_form.about_you"))
      .tap do |section|
        section.items = [
          ReferralSectionItem.new(
            I18n.t("referral_form.your_details"),
            path_for_section_status(
              check_answers?(referral.referrer&.complete),
              polymorphic_path(
                [:edit, referral.routing_scope, referral, :referrer_name]
              ),
              polymorphic_path(
                [
                  :edit,
                  referral.routing_scope,
                  referral,
                  :referrer,
                  :check_answers
                ]
              )
            ),
            section_status(referral.referrer&.complete)
          )
        ]

        if referral.from_employer?
          section.items.append(
            ReferralSectionItem.new(
              I18n.t("referral_form.your_organisation"),
              path_for_section_status(
                check_answers?(referral.organisation&.complete),
                polymorphic_path(
                  [
                    :edit,
                    referral.routing_scope,
                    referral,
                    :organisation_address
                  ]
                ),
                polymorphic_path(
                  [
                    :edit,
                    referral.routing_scope,
                    referral,
                    :organisation,
                    :check_answers
                  ]
                )
              ),
              section_status(referral.organisation&.complete)
            )
          )
        end
      end
  end

  def about_the_person_you_are_referring_section
    ReferralSection
      .new(2, I18n.t("referral_form.about_the_person_you_are_referring"))
      .tap do |section|
        section.items = [
          ReferralSectionItem.new(
            I18n.t("referral_form.personal_details"),
            path_for_section_status(
              check_answers?(referral.personal_details_complete),
              polymorphic_path(
                [
                  :edit,
                  referral.routing_scope,
                  referral,
                  :personal_details_name
                ]
              ),
              polymorphic_path(
                [
                  :edit,
                  referral.routing_scope,
                  referral,
                  :personal_details,
                  :check_answers
                ]
              )
            ),
            section_status(referral.personal_details_complete)
          )
        ]

        if referral.from_employer?
          section.items.append(
            ReferralSectionItem.new(
              I18n.t("referral_form.contact_details"),
              path_for_section_status(
                check_answers?(referral.contact_details_complete),
                polymorphic_path(
                  [
                    :edit,
                    referral.routing_scope,
                    referral,
                    :contact_details_email
                  ]
                ),
                polymorphic_path(
                  [
                    :edit,
                    referral.routing_scope,
                    referral,
                    :contact_details,
                    :check_answers
                  ]
                )
              ),
              section_status(referral.contact_details_complete)
            )
          )
        end

        section.items.append(
          ReferralSectionItem.new(
            I18n.t("referral_form.about_their_role"),
            path_for_section_status(
              check_answers?(referral.teacher_role_complete),
              polymorphic_path(
                [
                  :edit,
                  referral.routing_scope,
                  referral,
                  :teacher_role,
                  :job_title
                ]
              ),
              polymorphic_path(
                [
                  :edit,
                  referral.routing_scope,
                  referral,
                  :teacher_role,
                  :check_answers
                ]
              )
            ),
            section_status(referral.teacher_role_complete)
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
            path_for_section_status(
              check_answers?(referral.allegation_details_complete),
              polymorphic_path(
                [:edit, referral.routing_scope, referral, :allegation_details]
              ),
              polymorphic_path(
                [
                  :edit,
                  referral.routing_scope,
                  referral,
                  :allegation,
                  :check_answers
                ]
              )
            ),
            section_status(referral.allegation_details_complete)
          )
        ]

        if referral.from_employer?
          section.items.append(
            ReferralSectionItem.new(
              I18n.t("referral_form.previous_allegations"),
              path_for_section_status(
                check_answers?(referral.previous_misconduct_complete),
                polymorphic_path(
                  [
                    :edit,
                    referral.routing_scope,
                    referral,
                    :previous_misconduct_reported
                  ]
                ),
                polymorphic_path(
                  [
                    :edit,
                    referral.routing_scope,
                    referral,
                    :previous_misconduct,
                    :check_answers
                  ]
                )
              ),
              section_status(referral.previous_misconduct_complete)
            )
          )
        end

        section.items.append(
          ReferralSectionItem.new(
            I18n.t("referral_form.evidence_and_supporting_information"),
            path_for_section_status(
              check_answers?(referral.evidence_details_complete),
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
            section_status(referral.evidence_details_complete)
          )
        )
      end
  end

  def check_answers?(complete)
    !complete.nil?
  end

  def section_status(complete)
    complete ? :completed : :incomplete
  end

  def path_for_section_status(check_answers, start_path, check_answers_path)
    check_answers ? check_answers_path : start_path
  end
end
