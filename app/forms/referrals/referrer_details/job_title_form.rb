module Referrals
  module ReferrerDetails
    class JobTitleForm < FormItem
      attr_referrer :job_title

      validates :job_title, presence: true

      def save
        return false unless valid?

        referrer.update(job_title:)
      end

      def referrer
        @referrer ||= referral&.referrer || referral&.build_referrer
      end
    end
  end
end
