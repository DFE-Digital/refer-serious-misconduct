module Referrals
  module AllegationEvidence
    class UploadedForm < FormItem
      attr_accessor :more_evidence

      validates :more_evidence,
        inclusion: { in: %w[yes no] },
        on: :update,
        if: proc { |form| form.can_upload_more_evidence? }


      def more_evidence?
        @more_evidence == "yes"
      end

      delegate :can_upload_more_evidence?, to: :referral
    end
  end
end
