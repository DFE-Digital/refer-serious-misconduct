# frozen_string_literal: true
require "rails_helper"

RSpec.describe Referrals::TeacherRole::StartDateForm, type: :model do
  let(:referral) { build(:referral) }
  let(:role_start_date_known) { true }
  subject(:start_date_form) do
    described_class.new(referral:, role_start_date_known:)
  end

  describe "#valid?" do
    subject(:valid) { start_date_form.valid? }

    it { is_expected.to be_truthy }

    before { valid }

    context "when role_start_date_known is blank" do
      let(:role_start_date_known) { "" }

      it { is_expected.to be_falsy }

      it "adds an error" do
        expect(start_date_form.errors[:role_start_date_known]).to eq(
          ["Tell us if you know their role start date"]
        )
      end
    end
  end

  describe "#save" do
    context "when role_start_date_known is true" do
      let(:role_start_date_known) { true }

      before { start_date_form.save(params) }

      let(:params) do
        {
          "role_start_date(1i)" => "2000",
          "role_start_date(2i)" => "01",
          "role_start_date(3i)" => "01"
        }
      end

      it "updates the role start date" do
        expect(referral.role_start_date).to eq(Date.new(2000, 1, 1))
      end

      context "with a short month name" do
        let(:params) do
          {
            "role_start_date(1i)" => "2000",
            "role_start_date(2i)" => "Jan",
            "role_start_date(3i)" => "01"
          }
        end

        it "updates the role start date" do
          expect(referral.role_start_date).to eq(Date.new(2000, 1, 1))
        end
      end

      context "with a word for a number for the day and month" do
        let(:params) do
          {
            "role_start_date(1i)" => "2000",
            "role_start_date(2i)" => "tWeLvE  ",
            "role_start_date(3i)" => "One"
          }
        end

        it "updates the role start date" do
          expect(referral.role_start_date).to eq(Date.new(2000, 12, 1))
        end
      end

      context "without a valid date" do
        let(:params) do
          {
            "role_start_date(1i)" => "2000",
            "role_start_date(2i)" => "02",
            "role_start_date(3i)" => "30"
          }
        end

        it "does not update the role start date" do
          expect(referral.role_start_date).to be_nil
        end

        it "adds an error" do
          expect(start_date_form.errors[:role_start_date]).to eq(
            ["Enter their role start date in the correct format"]
          )
        end
      end

      context "with a blank date" do
        let(:params) do
          {
            "role_start_date(1i)" => "",
            "role_start_date(2i)" => "",
            "role_start_date(3i)" => ""
          }
        end

        it "adds an error" do
          expect(start_date_form.errors[:role_start_date]).to eq(
            ["Enter their role start date"]
          )
        end
      end

      context "when the date is in the future" do
        let(:params) do
          {
            "role_start_date(1i)" => 1.year.from_now.year,
            "role_start_date(2i)" => "01",
            "role_start_date(3i)" => "01"
          }
        end

        it "adds an error" do
          expect(start_date_form.errors[:role_start_date]).to eq(
            ["Their role start date must be in the past"]
          )
        end
      end

      context "with a year that is less than 4 digits" do
        let(:params) do
          {
            "role_start_date(1i)" => "99",
            "role_start_date(2i)" => "1",
            "role_start_date(3i)" => "1"
          }
        end

        it "adds an error" do
          expect(start_date_form.errors[:role_start_date]).to eq(
            ["Enter a year with 4 digits"]
          )
        end
      end

      context "with a missing day" do
        let(:params) do
          {
            "role_start_date(1i)" => "1990",
            "role_start_date(2i)" => "1",
            "role_start_date(3i)" => ""
          }
        end

        it "adds an error" do
          expect(start_date_form.errors[:role_start_date]).to eq(
            ["Enter a day for their role start date, formatted as a number"]
          )
        end
      end

      context "with a missing month" do
        let(:params) do
          {
            "role_start_date(1i)" => "1990",
            "role_start_date(2i)" => "",
            "role_start_date(3i)" => "1"
          }
        end

        it "adds an error" do
          expect(start_date_form.errors[:role_start_date]).to eq(
            ["Enter a month for their role start date, formatted as a number"]
          )
        end
      end

      context "with a whitespace month" do
        let(:params) do
          {
            "role_start_date(1i)" => "1990",
            "role_start_date(2i)" => " ",
            "role_start_date(3i)" => "1"
          }
        end

        it "adds an error" do
          expect(start_date_form.errors[:role_start_date]).to eq(
            ["Enter a month for their role start date, formatted as a number"]
          )
        end
      end

      context "with a word as a month" do
        let(:params) do
          {
            "role_start_date(1i)" => "1990",
            "role_start_date(2i)" => "Potatoes",
            "role_start_date(3i)" => "1"
          }
        end

        it "adds an error" do
          expect(start_date_form.errors[:role_start_date]).to eq(
            ["Enter a month for their role start date, formatted as a number"]
          )
        end
      end
    end

    context "when role_start_date_known is false" do
      let(:role_start_date_known) { false }

      it "updates the start_date_known to false" do
        expect { start_date_form.save }.to change(
          referral,
          :role_start_date_known
        ).from(nil).to(false)
      end
    end
  end
end
