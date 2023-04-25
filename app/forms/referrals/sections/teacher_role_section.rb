module Referrals
  module Sections
    class TeacherRoleSection < Section
      def items
        [
          Referrals::TeacherRole::JobTitleForm.new(referral:),
          Referrals::TeacherRole::DutiesForm.new(referral:)
        ].tap do |items|
          if referral.from_employer?
            items.append(Referrals::TeacherRole::SameOrganisationForm.new(referral:))
          end

          unless referral.same_organisation?
            items.append(Referrals::TeacherRole::OrganisationAddressKnownForm.new(referral:))
            if referral.organisation_address_known?
              items.append(Referrals::TeacherRole::OrganisationAddressForm.new(referral:))
            end
          end

          if referral.from_employer?
            items.append(Referrals::TeacherRole::StartDateForm.new(referral:))
            items.append(Referrals::TeacherRole::EmploymentStatusForm.new(referral:))

            if referral.left_role?
              items.append(Referrals::TeacherRole::EndDateForm.new(referral:))
              items.append(Referrals::TeacherRole::ReasonLeavingRoleForm.new(referral:))
              items.append(Referrals::TeacherRole::WorkingSomewhereElseForm.new(referral:))
              if referral.working_somewhere_else?
                items.append(Referrals::TeacherRole::WorkLocationKnownForm.new(referral:))
                if referral.work_location_known?
                  items.append(Referrals::TeacherRole::WorkLocationForm.new(referral:))
                end
              end
            end
          end

          items.append(Referrals::TeacherRole::CheckAnswersForm.new(referral:))
        end
      end

      def slug
        "teacher_role"
      end

      def complete?
        referral.teacher_role_complete
      end

      def view_component(**args)
        TheirRoleComponent.new(referral:, **args)
      end
    end
  end
end
