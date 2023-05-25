module Referrals
  module Sections
    class TeacherRoleSection < Section
      def items
        [].tap do |items|
          items << Referrals::TeacherRole::JobTitleForm.new(referral:)
          items << Referrals::TeacherRole::DutiesForm.new(referral:)

          if referral.from_employer?
            items << Referrals::TeacherRole::SameOrganisationForm.new(referral:)
          end

          unless referral.same_organisation?
            items << Referrals::TeacherRole::OrganisationAddressKnownForm.new(referral:)

            if referral.organisation_address_known?
              items << Referrals::TeacherRole::OrganisationAddressForm.new(referral:)
            end
          end

          if referral.from_employer?
            items << Referrals::TeacherRole::StartDateForm.new(referral:)
            items << Referrals::TeacherRole::EmploymentStatusForm.new(referral:)

            if referral.left_role?
              items << Referrals::TeacherRole::EndDateForm.new(referral:)
              items << Referrals::TeacherRole::ReasonLeavingRoleForm.new(referral:)
              items << Referrals::TeacherRole::WorkingSomewhereElseForm.new(referral:)

              if referral.working_somewhere_else?
                items << Referrals::TeacherRole::WorkLocationKnownForm.new(referral:)

                if referral.work_location_known?
                  items << Referrals::TeacherRole::WorkLocationForm.new(referral:)
                end
              end
            end
          end

          items << Referrals::TeacherRole::CheckAnswersForm.new(referral:)
        end
      end

      def complete?
        referral.teacher_role_complete
      end

      def view_component(**args)
        TeacherRoleComponent.new(referral:, **args)
      end
    end
  end
end
