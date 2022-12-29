module Referrals
  module Evidence
    class UploadedForm
      include ActiveModel::Model

      attr_accessor :more_evidence

      validates :more_evidence, inclusion: { in: %w[yes no] }

      def more_evidence?
        @more_evidence == "yes"
      end
    end
  end
end
