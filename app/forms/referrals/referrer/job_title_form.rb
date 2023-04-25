module Referrals
  module Referrer
    class JobTitleForm
      include ReferralFormSection

      attr_writer :job_title

      validates :job_title, presence: true

      def slug
        "referrer_job_title"
      end

      def job_title
        @job_title ||= referrer&.job_title
      end

      def save
        return false unless valid?

        referrer.update(job_title:)
      end

      private

      def referrer
        @referrer ||= referral&.referrer || referral&.build_referrer
      end
    end
  end
end
