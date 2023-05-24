module Referrals
  module Evidence
    class UploadedForm < FormItem
      attr_accessor :more_evidence

      validates :more_evidence, inclusion: { in: %w[yes no] }, on: :update

      def slug
        "evidence_uploaded"
      end

      def more_evidence?
        @more_evidence == "yes"
      end
    end
  end
end
