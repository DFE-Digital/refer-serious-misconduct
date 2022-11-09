# == Schema Information
#
# Table name: users
#
#  id                  :bigint           not null, primary key
#  current_sign_in_at  :datetime
#  current_sign_in_ip  :string
#  email               :string           default(""), not null
#  last_sign_in_at     :datetime
#  last_sign_in_ip     :string
#  remember_created_at :datetime
#  secret_key          :string
#  sign_in_count       :integer          default(0), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
require "rails_helper"

RSpec.describe User, type: :model do
  describe "#latest_referral" do
    it "returns the most recently created referral" do
      user = create(:user)
      expected_referral =
        create(:referral, user:, created_at: Time.zone.now + 1.hour)
      create(:referral, user:, created_at: Time.zone.now)
      create(:referral, user:, created_at: Time.zone.now - 1.hour)

      expect(user.latest_referral).to eq expected_referral
    end
  end
end
