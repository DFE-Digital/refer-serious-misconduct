module Referrals
  module AllegationEvidence
    class UploadedForm < FormItem
      attr_accessor :more_evidence

      validates :more_evidence,
        inclusion: { in: %w[yes no] },
        on: :update,
        if: Proc.new { |form| form.can_upload_more_evidence? }


      def more_evidence?
        @more_evidence == "yes"
      end

      def can_upload_more_evidence?
        referral.can_upload_more_evidence?
      end
    end
  end
end
