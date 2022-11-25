require "rails_helper"

RSpec.describe ReferralForm do
  describe "save" do
    let(:sections) do
      [
        OpenStruct.new(
          items: [
            OpenStruct.new(status: :incomplete),
            OpenStruct.new(status: :completed)
          ]
        ),
        OpenStruct.new(
          items: [
            OpenStruct.new(status: :completed),
            OpenStruct.new(status: :completed)
          ]
        )
      ]
    end

    subject(:form) { described_class.new(referral: Referral.new) }

    before { allow(form).to receive(:sections).and_return(sections) }

    it "checks statuses of referral sections" do
      expect(form.save).to be false
    end

    context "when statuses are all complete" do
      let(:sections) do
        [
          OpenStruct.new(
            items: [
              OpenStruct.new(status: :completed),
              OpenStruct.new(status: :completed)
            ]
          ),
          OpenStruct.new(
            items: [
              OpenStruct.new(status: :completed),
              OpenStruct.new(status: :completed)
            ]
          )
        ]
      end

      it "checks statuses of referral sections" do
        expect(form.save).to be true
      end
    end
  end
end
