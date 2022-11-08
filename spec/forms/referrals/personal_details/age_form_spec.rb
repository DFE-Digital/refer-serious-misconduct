# frozen_string_literal: true
require "rails_helper"

RSpec.describe Referrals::PersonalDetails::AgeForm, type: :model do
  let(:referral) { Referral.new }
  subject(:age_form) { described_class.new(referral:) }

  describe "#save" do
    let(:params) do
      {
        "date_of_birth(1i)" => "2000",
        "date_of_birth(2i)" => "01",
        "date_of_birth(3i)" => "01"
      }
    end

    it "updates the date of birth" do
      age_form.save(params)
      expect(referral.date_of_birth).to eq(Date.new(2000, 1, 1))
    end

    context "with a short month name" do
      let(:params) do
        {
          "date_of_birth(1i)" => "2000",
          "date_of_birth(2i)" => "Jan",
          "date_of_birth(3i)" => "01"
        }
      end

      it "updates the date of birth" do
        expect(age_form.save(params)).to be true
        expect(referral.date_of_birth).to eq(Date.new(2000, 1, 1))
      end
    end

    context "with a word for a number for the day and month" do
      let(:params) do
        {
          "date_of_birth(1i)" => "2000",
          "date_of_birth(2i)" => "tWeLvE  ",
          "date_of_birth(3i)" => "One"
        }
      end

      it "updates the date of birth" do
        expect(age_form.save(params)).to be true
        expect(referral.date_of_birth).to eq(Date.new(2000, 12, 1))
      end
    end

    context "without a valid date" do
      let(:params) do
        {
          "date_of_birth(1i)" => "2000",
          "date_of_birth(2i)" => "02",
          "date_of_birth(3i)" => "30"
        }
      end

      it "does not update the date of birth" do
        expect(age_form.save(params)).to be_falsy
        expect(referral.date_of_birth).to be_nil
      end

      it "adds an error" do
        age_form.save(params)
        expect(age_form.errors[:date_of_birth]).to eq(
          ["Enter their date of birth in the correct format"]
        )
      end
    end

    context "with a blank date" do
      let(:params) do
        {
          "date_of_birth(1i)" => "",
          "date_of_birth(2i)" => "",
          "date_of_birth(3i)" => ""
        }
      end

      it "adds an error" do
        age_form.save(params)
        expect(age_form.errors[:date_of_birth]).to eq(
          ["Enter their date of birth"]
        )
      end
    end

    context "when the date is in the future" do
      let(:params) do
        {
          "date_of_birth(1i)" => 1.year.from_now.year,
          "date_of_birth(2i)" => "01",
          "date_of_birth(3i)" => "01"
        }
      end

      it "adds an error" do
        age_form.save(params)
        expect(age_form.errors[:date_of_birth]).to eq(
          ["Their date of birth must be in the past"]
        )
      end
    end

    context "with a date less than 16 years ago" do
      let(:params) do
        {
          "date_of_birth(1i)" => 15.years.ago.year,
          "date_of_birth(2i)" => Time.zone.today.month,
          "date_of_birth(3i)" => Time.zone.today.day
        }
      end

      it "adds an error" do
        age_form.save(params)
        expect(age_form.errors[:date_of_birth]).to eq(
          ["You must be 16 or over to use this service"]
        )
      end
    end

    context "with a date before 1900" do
      let(:params) do
        {
          "date_of_birth(1i)" => "1899",
          "date_of_birth(2i)" => "1",
          "date_of_birth(3i)" => "1"
        }
      end

      it "adds an error" do
        age_form.save(params)
        expect(age_form.errors[:date_of_birth]).to eq(
          ["Enter a year of birth later than 1900"]
        )
      end
    end

    context "with a year that is less than 4 digits" do
      let(:params) do
        {
          "date_of_birth(1i)" => "99",
          "date_of_birth(2i)" => "1",
          "date_of_birth(3i)" => "1"
        }
      end

      it "adds an error" do
        age_form.save(params)
        expect(age_form.errors[:date_of_birth]).to eq(
          ["Enter a year with 4 digits"]
        )
      end
    end

    context "with a missing day" do
      let(:params) do
        {
          "date_of_birth(1i)" => "1990",
          "date_of_birth(2i)" => "1",
          "date_of_birth(3i)" => ""
        }
      end

      it "adds an error" do
        age_form.save(params)
        expect(age_form.errors[:date_of_birth]).to eq(
          ["Enter a day for their date of birth, formatted as a number"]
        )
      end
    end

    context "with a missing month" do
      let(:params) do
        {
          "date_of_birth(1i)" => "1990",
          "date_of_birth(2i)" => "",
          "date_of_birth(3i)" => "1"
        }
      end

      it "adds an error" do
        age_form.save(params)
        expect(age_form.errors[:date_of_birth]).to eq(
          ["Enter a month for their date of birth, formatted as a number"]
        )
      end
    end

    context "with a whitespace month" do
      let(:params) do
        {
          "date_of_birth(1i)" => "1990",
          "date_of_birth(2i)" => " ",
          "date_of_birth(3i)" => "1"
        }
      end

      it "adds an error" do
        age_form.save(params)
        expect(age_form.errors[:date_of_birth]).to eq(
          ["Enter a month for their date of birth, formatted as a number"]
        )
      end
    end

    context "with a word as a month" do
      let(:params) do
        {
          "date_of_birth(1i)" => "1990",
          "date_of_birth(2i)" => "Potatoes",
          "date_of_birth(3i)" => "1"
        }
      end

      it "adds an error" do
        age_form.save(params)
        expect(age_form.errors[:date_of_birth]).to eq(
          ["Enter a month for their date of birth, formatted as a number"]
        )
      end
    end
  end
end
