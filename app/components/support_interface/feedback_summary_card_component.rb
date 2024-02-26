module SupportInterface
  class FeedbackSummaryCardComponent < ViewComponent::Base
    include ActiveModel::Model

    attr_accessor :feedback

    def rows
      feedback
        .attributes
        .keep_if { |k,_v| whitelisted_keys.include?(k) }
        .map do |k,v|
          {
            key: { text: k.humanize },
            value: { text: formatted_value(v) }
          }
        end
    end

    def title
      feedback.id
    end

    private

    def formatted_value(value)
      case value
      when String
        value
      when TrueClass
        "Yes"
      when FalseClass
        "No"
      when ActiveSupport::TimeWithZone
        value.to_formatted_s(:govuk_time_on_date)
      else
        value.class
      end
    end

    def whitelisted_keys
      %w[
        satisfaction_rating
        improvement_suggestion
        contact_permission_given
        email
        created_at
      ]
    end
  end
end
