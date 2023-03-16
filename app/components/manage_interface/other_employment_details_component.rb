module ManageInterface
  class OtherEmploymentDetailsComponent < ViewComponent::Base
    include ActiveModel::Model
    include AddressHelper

    attr_accessor :referral

    def rows
      [{ key: { text: "Organisation" }, value: { text: teaching_address(referral) } }]
    end

    def title
      "Other employment details"
    end
  end
end
