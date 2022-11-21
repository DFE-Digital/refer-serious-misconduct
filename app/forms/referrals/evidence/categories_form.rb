# frozen_string_literal: true
module Referrals
  module Evidence
    class CategoriesForm
      include ActiveModel::Model

      CATEGORIES = %w[
        cv
        references
        job_application
        job_offer
        job_description
        conduct_behaviour_attitude
        statements_made
        internal_investigations
        past_disciplinary_actions
        police_investigations
        local_authority_investigations
        reports_from_other_agencies
        signed_witness_statements
        dismissal_resignation_letters
        interview_reports
        minutes_strategy_meetings
      ].freeze

      validates :categories, presence: true
      validates :categories_other,
                presence: true,
                if: -> { categories&.include?("other") }

      attr_accessor :referral, :evidence
      attr_writer :categories_other

      def categories=(value)
        @categories = value&.compact_blank
      end

      def categories
        @categories ||= evidence.categories
      end

      def categories_other
        @categories_other ||= evidence.categories_other
      end

      def evidences
        @evidences ||= referral.evidences
      end

      def next_evidence
        index = evidences.index(evidence)
        return if index.nil?

        evidences[index + 1]
      end

      def save
        return false if invalid?

        evidence.update(categories:, categories_other:)
        true
      end

      def self.selected_categories(evidence)
        selected =
          evidence.categories.map { |k| category_label(k) }.compact_blank
        if evidence.categories.include?("other")
          selected << "Other: #{evidence.categories_other}"
        end
        selected
      end

      def self.category_label(key)
        I18n.t("referral_evidence.categories.#{key}", default: "")
      end
    end
  end
end
