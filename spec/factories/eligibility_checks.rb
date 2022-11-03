# == Schema Information
#
# Table name: eligibility_checks
#
#  id                    :bigint           not null, primary key
#  complained            :boolean
#  is_teacher            :string
#  reporting_as          :string           not null
#  serious_misconduct    :string
#  teaching_in_england   :string
#  unsupervised_teaching :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
FactoryBot.define do
  factory :eligibility_check do
    reporting_as { "employer" }

    trait :complete do
      is_teacher { "yes" }
      teaching_in_england { "yes" }
      serious_misconduct { "yes" }
    end

    trait :not_unsupervised do
      is_teacher { "no" }
      unsupervised_teaching { "no" }
    end
  end
end
