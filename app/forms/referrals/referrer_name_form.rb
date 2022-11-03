module Referrals
  class ReferrerNameForm
    include ActiveModel::Model

    attr_accessor :referral
    attr_writer :name

    validates :name, presence: true
    validates :referral, presence: true

    def name
      @name ||= referrer&.name
    end

    def save
      return false unless valid?

      referrer.update(name:)
    end

    private

    def referrer
      @referrer ||= referral&.referrer || referral&.build_referrer
    end
  end
end
