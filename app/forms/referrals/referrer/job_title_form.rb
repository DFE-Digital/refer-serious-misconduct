module Referrals
  module Referrer
    class JobTitleForm
      include ActiveModel::Model

      attr_accessor :referral
      attr_writer :job_title

      validates :job_title, presence: true
      validates :referral, presence: true

      def job_title
        @job_title ||= referrer&.job_title
      end

      def save
        return false unless valid?

        referrer.update(job_title:)
      end

      delegate :referrer, to: :referral, allow_nil: true
    end
  end
end
