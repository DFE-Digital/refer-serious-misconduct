require "rails_helper"

class TestClass
  include CustomAttrs

  attr_accessor :referral, :referrer, :organisation
  attr_referral :email_known, :email_address
  attr_organisation :name, :street_1
  attr_referrer :first_name, :last_name
end

RSpec.describe CustomAttrs do
  let(:test_class) { TestClass.new }

  describe ".attr_referral" do
    let(:email_known) { test_class.email_known }
    let(:email_address) { test_class.email_address }

    context "when the class doesn't have a referral object" do
      it "returns nil" do
        expect(email_known).to eq(nil)
        expect(email_address).to eq(nil)
      end
    end

    context "when the class has a referral object" do
      let(:referral) { build(:referral, email_known: true, email_address: "test@example.com") }

      before { test_class.referral = referral }

      it "returns the referral's values" do
        expect(email_known).to eq(true)
        expect(email_address).to eq("test@example.com")
      end

      context "when updating the values" do
        before do
          test_class.email_known = "false"
          test_class.email_address = "  example@test.com  "
        end

        it "returns the referral's updated values" do
          expect(email_known).to eq(false)
          expect(email_address).to eq("example@test.com")
        end
      end
    end
  end

  describe ".attr_organisation" do
    let(:name) { test_class.name }
    let(:street_1) { test_class.street_1 }

    context "when the class doesn't have an organisation object" do
      it "returns nil" do
        expect(name).to eq(nil)
        expect(street_1).to eq(nil)
      end
    end

    context "when the class has an organisation object" do
      let(:referral) { build(:referral, organisation:) }
      let(:organisation) { build(:organisation, name: "Org", street_1: "High Street") }

      before { test_class.organisation = organisation }

      it "returns the organisation's values" do
        expect(name).to eq("Org")
        expect(street_1).to eq("High Street")
      end

      context "when updating the values" do
        before do
          test_class.name = "Org 2"
          test_class.street_1 = "Low Street"
        end

        it "returns the organisation's updated values" do
          expect(name).to eq("Org 2")
          expect(street_1).to eq("Low Street")
        end
      end
    end
  end

  describe ".attr_referrer" do
    let(:first_name) { test_class.first_name }
    let(:last_name) { test_class.last_name }

    context "when the class doesn't have a referrer object" do
      it "returns nil" do
        expect(first_name).to eq(nil)
        expect(last_name).to eq(nil)
      end
    end

    context "when the class has a referrer object" do
      let(:referral) { build(:referral, referrer:) }
      let(:referrer) { build(:referrer, first_name: "John", last_name: "Doe") }

      before { test_class.referrer = referrer }

      it "returns the referrer's values" do
        expect(first_name).to eq("John")
        expect(last_name).to eq("Doe")
      end

      context "when updating the values" do
        before do
          test_class.first_name = "Jane"
          test_class.last_name = "Doey"
        end

        it "returns the referral's updated values" do
          expect(first_name).to eq("Jane")
          expect(last_name).to eq("Doey")
        end
      end
    end
  end
end
