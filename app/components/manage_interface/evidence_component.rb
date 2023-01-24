module ManageInterface
  class EvidenceComponent < ViewComponent::Base
    include ActiveModel::Model

    attr_accessor :referral
  end
end
