module Referrals
  class ReferrerNameForm
    include ActiveModel::Model

    attr_accessor :referral
    attr_writer :first_name, :last_name

    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :referral, presence: true

    def first_name
      @first_name ||= referrer&.first_name
    end

    def last_name
      @last_name ||= referrer&.last_name
    end

    def save
      return false unless valid?

      referrer.update(first_name:, last_name:)
    end

    private

    def referrer
      @referrer ||= referral&.referrer || referral&.build_referrer
    end
  end
end
