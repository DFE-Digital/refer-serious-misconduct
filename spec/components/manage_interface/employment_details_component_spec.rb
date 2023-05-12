require "rails_helper"

RSpec.describe ManageInterface::EmploymentDetailsComponent, type: :component do
  subject(:component) { described_class.new(referral:) }

  let(:row_labels) { component.rows.map { |row| row.dig(:key, :text) } }
  let(:referral) { create(:referral, :public_complete) }
  let(:row_values) { component.rows.map { |row| row.dig(:value, :text) }.map(&:strip) }
  let(:row_values_sanitized) do
    row_values.map { |value| ActionView::Base.full_sanitizer.sanitize(value) }
  end

  before { render_inline(component) }

  it "renders the job title row" do
    expect(row_labels[0]).to eq("Job title")
    expect(row_values_sanitized[0]).to eq("Teacher")
  end

  it "renders the details about their main duties" do
    expect(row_labels[1]).to eq("How were details about their main duties given?")
    expect(row_values_sanitized[1]).to eq("Describe their main duties")
  end

  it "renders their main duties" do
    expect(row_labels[2]).to eq("Main duties")
    expect(row_values_sanitized[2]).to eq("Teaching children in year 2")
  end

  context "when the organisation address where misconduct took place is known" do
    it "renders the organisation address" do
      expect(row_labels[3]).to eq(
        "Name and address of the organisation where the alleged misconduct took place"
      )
      expect(row_values_sanitized[3]).to eq(
        "Example School1 Example StreetDifferent RoadExample TownW1 1AA"
      )
    end
  end

  context "when the organisation address where the misconduct took place is unknown" do
    let(:referral) { create(:referral, :public_complete, organisation_address_known: false) }

    it "renders 'Do you know the name and address of the organisation where the alleged misconduct took place?'" do
      expect(row_labels[3]).to eq(
        "Do you know the name and address of the organisation where the alleged misconduct took place?"
      )
      expect(row_values_sanitized[3]).to eq("No")
    end
  end

  context "when the referral is not from an employer" do
    let(:referral) { create(:referral, :public_complete) }

    it "does not render any information about the organisation where the person was employed" do
      expect(row_labels).not_to include(
        "Were they employed at the same organisation as you at the time of the alleged misconduct?"
      )
      expect(row_labels).not_to include("Organisation")
    end

    it "does not render any information about job start date" do
      expect(row_labels).not_to include("Do you know when they started the job?", "Job start date")
    end

    it "does not render any information about the past employment" do
      expect(row_labels).not_to include(
        "Are they still employed at the organisation where the alleged misconduct took place?"
      )
      expect(row_labels).not_to include("Job end date")
      expect(row_labels).not_to include("Do you know when they left the job?")
      expect(row_labels).not_to include("Reason they left the job")
      expect(row_labels).not_to include("Are they employed somewhere else?")
      expect(row_labels).not_to include(
        "Do you know the name and address of the organisation where they’re employed?"
      )
    end
  end

  context "when the referral is from the same organisation" do
    let(:referral) { create(:referral, :employer_complete) }

    it "renders the address of organisation" do
      expect(row_labels[4]).to eq(
        "Were they employed at the same organisation as you at the time of the alleged misconduct?"
      )
      expect(row_values_sanitized[4]).to eq("No")
    end
  end

  context "when the referral is not from the same organisation" do
    let(:referral) { create(:referral, :employer_complete, same_organisation: false) }

    it "renders 'Were they employed at the same organisation as you at the time of the alleged misconduct?'" do
      expect(row_labels[4]).to eq(
        "Were they employed at the same organisation as you at the time of the alleged misconduct?"
      )
      expect(row_values_sanitized[4]).to eq("No")
    end
  end

  context "when the referral's job start date is known" do
    let(:referral) { create(:referral, :employer_complete) }

    it "renders the job start date" do
      expect(row_labels[5]).to eq("Job start date")
      expect(row_values_sanitized[5]).to eq("10 April 2022")
    end
  end

  context "when the referral's job start date is unknown" do
    let(:referral) { create(:referral, :employer_complete, role_start_date_known: false) }

    it "renders 'Do you know when they started the job?'" do
      expect(row_labels[5]).to eq("Do you know when they started the job?")
      expect(row_values_sanitized[5]).to eq("No")
    end
  end

  context "when the referral is still employed, suspended or the referrer is unsure" do
    let(:referral) { create(:referral, :employer_complete, employment_status: "Yes") }

    it "does not render any information about the past employment" do
      expect(row_labels).not_to include(
        "Are they still employed at the organisation where the alleged misconduct took place?"
      )
      expect(row_labels).not_to include("Job end date")
      expect(row_labels).not_to include("Do you know when they left the job?")
      expect(row_labels).not_to include("Reason they left the job")
      expect(row_labels).not_to include("Are they employed somewhere else?")
      expect(row_labels).not_to include(
        "Do you know the name and address of the organisation where they’re employed?"
      )
    end
  end

  context "when the referral left the role" do
    let(:referral) { create(:referral, :employer_complete, employment_status: "left_role") }

    it "renders 'Are they still employed at the organisation where the alleged misconduct took place?'" do
      expect(row_labels[6]).to eq(
        "Are they still employed at the organisation where the alleged misconduct took place?"
      )
      expect(row_values_sanitized[6]).to eq("No")
    end

    it "renders the role end date is date is known" do
      expect(row_labels[7]).to eq("Job end date")
      expect(row_values_sanitized[7]).to eq("10 March 2023")
    end

    context "when the end date is not known" do
      let(:referral) do
        create(
          :referral,
          :employer_complete,
          employment_status: "left_role",
          role_end_date_known: false
        )
      end

      it "renders 'Do you know when they left the job?'" do
        expect(row_labels[7]).to eq("Do you know when they left the job?")
        expect(row_values_sanitized[7]).to eq("No")
      end
    end

    it "renders the reason for leaving" do
      expect(row_labels[8]).to eq("Reason they left the job")
      expect(row_values_sanitized[8]).to eq("Dismissed")
    end

    context "when referrer does not know for fact if referral works somewhere else" do
      let(:referral) do
        create(
          :referral,
          :employer_complete,
          employment_status: "left_role",
          working_somewhere_else: "not_sure"
        )
      end

      it "renders 'Are they employed somewhere else?'" do
        expect(row_labels[9]).to eq("Are they employed somewhere else?")
        expect(row_values_sanitized[9]).to eq("I'm not sure")
      end
    end

    context "when referrer knows the referral works somewhere else, but does not know the new work location" do
      let(:referral) do
        create(
          :referral,
          :employer_complete,
          employment_status: "left_role",
          working_somewhere_else: "yes",
          work_location_known: nil
        )
      end

      it "renders 'Are they employed somewhere else?'" do
        expect(row_labels[9]).to eq(
          "Do you know the name and address of the organisation where they’re employed?"
        )
        expect(row_values_sanitized[9]).to eq("No")
      end
    end
  end
end
