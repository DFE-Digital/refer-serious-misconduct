require "rails_helper"

RSpec.describe DeveloperPolicy do
  subject(:policy) { described_class.new(user, record) }

  let(:user) { nil }
  let(:record) { :developer }

  [:index?, :deactivate?, :activate?].each do |action|
    describe "##{action}" do
      context "when developer" do
        let(:user) { build(:staff, :developer) }

        it "can be performed" do
          expect(policy.public_send(action)).to be_truthy
        end
      end

      context "when non-developer" do
        let(:user) { build(:staff) }

        it "cannot be performed" do
          expect(policy.public_send(action)).to be_falsey
        end
      end
    end
  end
end
