require "rails_helper"

RSpec.describe ManageInterface::PersonalDetailsComponent, type: :component do
  subject(:component) { described_class.new(referral:) }

  let(:row_labels) { component.rows.map { |row| row.dig(:key, :text) } }
  let(:row_values) { component.rows.map { |row| row.dig(:value, :text) }.map(&:strip) }
  let(:row_values_sanitized) do
    row_values.map { |value| ActionView::Base.full_sanitizer.sanitize(value) }
  end

  before { render_inline(component) }

  context "with an employer referral" do
    let(:referral) { create(:referral, :employer_complete) }

    it "renders the correct labels" do
      expect(row_labels).to eq(
        [
          "First name",
          "Last name",
          "Do you know them by any other name?",
          "Date of birth",
          "Email address",
          "Phone number",
          "Address",
          "National Insurance number",
          "Teacher reference number (TRN)?",
          "Do they have qualified teacher status?"
        ]
      )
    end

    it "renders the correct values" do
      expect(row_values_sanitized).to eq(
        [
          "John",
          "Smith",
          "No",
          "15 May 1993",
          "test@example.com",
          "01234567890",
          "1 Example StreetExample TownW1 1AA",
          "XH259197C",
          "1234567",
          "Yes"
        ]
      )
    end

    context "when the previous name has changed" do
      before { referral.update!(name_has_changed: "yes", previous_name: "Johnny Doe") }

      it "renders the correct labels" do
        expect(row_labels[2]).to eq("Other name")
      end

      it "renders the correct values" do
        expect(row_values[2]).to eq("Johnny Doe")
      end
    end

    context "when the date of birth is known" do
      before { referral.update!(age_known: true, date_of_birth: Date.new(2000, 1, 1)) }

      it "renders the correct labels" do
        expect(row_labels[3]).to eq("Date of birth")
      end

      it "renders the correct values" do
        expect(row_values[3]).to eq("1 January 2000")
      end
    end

    context "when the email address is not known" do
      before { referral.update!(email_known: false) }

      it "renders the correct labels" do
        expect(row_labels[4]).to eq("Do you know their email address?")
      end

      it "renders the correct values" do
        expect(row_values[4]).to eq("No")
      end
    end

    context "when the phone number is not known" do
      before { referral.update!(phone_known: false) }

      it "renders the correct labels" do
        expect(row_labels[5]).to eq("Do you know their phone number?")
      end

      it "renders the correct values" do
        expect(row_values[5]).to eq("No")
      end
    end

    context "when the address is not known" do
      before { referral.update!(address_known: false) }

      it "renders the correct labels" do
        expect(row_labels[6]).to eq("Do you know their address?")
      end

      it "renders the correct values" do
        expect(row_values[6]).to eq("No")
      end
    end

    context "when the NINO is not known" do
      before { referral.update!(ni_number_known: false) }

      it "renders the correct labels" do
        expect(row_labels[7]).to eq("Do you know their National Insurance number?")
      end

      it "renders the correct values" do
        expect(row_values[7]).to eq("No")
      end
    end

    context "when the TRN is not known" do
      before { referral.update!(trn: nil) }

      it "renders the correct labels" do
        expect(row_labels[8]).to eq("Do you know their teacher reference number (TRN)?")
      end

      it "renders the correct values" do
        expect(row_values[8]).to eq("No")
      end
    end
  end

  context "with a public referral" do
    let(:referral) { create(:referral, :public_complete) }

    it "renders the correct labels" do
      expect(row_labels).to eq(["First name", "Last name", "Do you know them by any other name?"])
    end

    it "renders the correct values" do
      expect(row_values).to eq(%w[John Smith No])
    end
  end
end
