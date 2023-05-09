require "rails_helper"

RSpec.describe TheirRoleComponent, type: :component do
  subject(:component) { described_class.new(referral:) }

  let(:referrer) { referral.referrer }
  let(:row_labels) { component.rows.map { |row| row.dig(:key, :text) } }
  let(:row_values) { component.rows.map { |row| row.dig(:value, :text) }.map(&:strip) }
  let(:row_links) { component.rows.map { |row| row.dig(:actions, :href) } }

  before { render_inline(component) }

  context "without their role answers" do
    let(:referral) { create(:referral, :complete) }

    it "renders the labels" do
      expect(row_labels).to eq(
        [
          "Their job title",
          "How do you want to give details about their main duties?",
          "Description of their role",
          "Were they employed at the same organisation as you at the time of the alleged misconduct?",
          "Do you know when they started the job?",
          "Are they still employed at the organisation where the alleged misconduct took place?"
        ]
      )
    end

    it "renders the values" do
      expect(row_values).to eq(
        [
          "Not answered",
          "Not answered",
          "Not answered",
          "Not answered",
          "Not answered",
          "Not answered"
        ]
      )
    end

    it "renders the change links" do
      expect(row_links).to eq(
        [
          "/referrals/#{referral.id}/teacher-role/job-title/edit?return_to=%2F",
          "/referrals/#{referral.id}/teacher-role/duties/edit?return_to=%2F",
          "/referrals/#{referral.id}/teacher-role/duties/edit?return_to=%2F",
          "/referrals/#{referral.id}/teacher-role/same-organisation/edit?return_to=%2F",
          "/referrals/#{referral.id}/teacher-role/start-date/edit?return_to=%2F",
          "/referrals/#{referral.id}/teacher-role/employment-status/edit?return_to=%2F"
        ]
      )
    end
  end

  context "with all their role answers" do
    let(:referral) do
      create(
        :referral,
        :complete,
        job_title: "Teacher",
        duties_format: "details",
        duties_details: "Teaches computing",
        same_organisation: false,
        organisation_address_known: true,
        organisation_name: "Organisation name",
        organisation_address_line_1: "Organisation address_line_1",
        organisation_address_line_2: "Organisation address_line_2",
        organisation_town_or_city: "Organisation town_or_city",
        organisation_postcode: "AM120PM",
        role_start_date_known: true,
        role_start_date: Date.new(2021, 12, 25),
        employment_status: "left_role",
        role_end_date_known: true,
        role_end_date: Date.new(2022, 12, 25),
        reason_leaving_role: "resigned",
        working_somewhere_else: "yes",
        work_location_known: true,
        work_organisation_name: "Work organisation_name",
        work_address_line_1: "Work address_line_1",
        work_address_line_2: "Work address_line_2",
        work_town_or_city: "Work town_or_city",
        work_postcode: "AM121PM"
      )
    end

    it "renders the labels" do
      expect(row_labels).to eq(
        [
          "Their job title",
          "How do you want to give details about their main duties?",
          "Description of their role",
          "Were they employed at the same organisation as you at the time of the alleged misconduct?",
          "Do you know the name and address of the organisation where the alleged misconduct took place?",
          "Name and address of the organisation where the alleged misconduct took place",
          "Do you know when they started the job?",
          "Job start date",
          "Are they still employed at the organisation where the alleged misconduct took place?",
          "Do you know when they left the job?",
          "Job end date",
          "Reason they left the job",
          "Are they employed somewhere else?",
          "Do you know the name and address of the organisation where they’re employed?",
          "Name and address of the organisation where they’re employed"
        ]
      )
    end

    it "renders the values" do
      expect(row_values).to eq(
        [
          "Teacher",
          "Describe their main duties",
          "<p>Teaches computing</p>",
          "No",
          "Yes",
          "Organisation name<br />Organisation address_line_1<br />Organisation " \
            "address_line_2<br />Organisation town_or_city<br />AM120PM",
          "Yes",
          "25 December 2021",
          "No",
          "Yes",
          "25 December 2022",
          "Resigned",
          "Yes",
          "Yes",
          "Work organisation_name<br />Work address_line_1<br />Work address_line_2<br />Work town_or_city<br />AM121PM"
        ]
      )
    end

    it "renders the change links" do
      expect(row_links).to eq(
        [
          "/referrals/#{referral.id}/teacher-role/job-title/edit?return_to=%2F",
          "/referrals/#{referral.id}/teacher-role/duties/edit?return_to=%2F",
          "/referrals/#{referral.id}/teacher-role/duties/edit?return_to=%2F",
          "/referrals/#{referral.id}/teacher-role/same-organisation/edit?return_to=%2F",
          "/referrals/#{referral.id}/teacher-role/organisation-address-known/edit?return_to=%2F",
          "/referrals/#{referral.id}/teacher-role/organisation-address/edit?return_to=%2F",
          "/referrals/#{referral.id}/teacher-role/start-date/edit?return_to=%2F",
          "/referrals/#{referral.id}/teacher-role/start-date/edit?return_to=%2F",
          "/referrals/#{referral.id}/teacher-role/employment-status/edit?return_to=%2F",
          "/referrals/#{referral.id}/teacher-role/end-date/edit?return_to=%2F",
          "/referrals/#{referral.id}/teacher-role/end-date/edit?return_to=%2F",
          "/referrals/#{referral.id}/teacher-role/reason-leaving-role/edit?return_to=%2F",
          "/referrals/#{referral.id}/teacher-role/working-somewhere-else/edit?return_to=%2F",
          "/referrals/#{referral.id}/teacher-role/work-location-known/edit?return_to=%2F",
          "/referrals/#{referral.id}/teacher-role/work-location/edit?return_to=%2F"
        ]
      )
    end
  end

  context "with some of their role answers as employer" do
    let(:referral) { create(:referral, :employer, :teacher_role_employer) }

    it "renders the labels" do
      expect(row_labels).to eq(
        [
          "Their job title",
          "How do you want to give details about their main duties?",
          "Description of their role",
          "Were they employed at the same organisation as you at the time of the alleged misconduct?",
          "Do you know when they started the job?",
          "Job start date",
          "Are they still employed at the organisation where the alleged misconduct took place?",
          "Do you know when they left the job?",
          "Job end date",
          "Reason they left the job",
          "Are they employed somewhere else?",
          "Do you know the name and address of the organisation where they’re employed?",
          "Name and address of the organisation where they’re employed"
        ]
      )
    end

    it "renders the values" do
      expect(row_values).to eq(
        [
          "Teacher",
          "Describe their main duties",
          "<p>Teaching children in year 2</p>",
          "Yes",
          "Yes",
          "10 April 2022",
          "No",
          "Yes",
          "10 March 2023",
          "Dismissed",
          "Yes",
          "Yes",
          "Different School<br />2 Different Street<br />Same Road<br />Example Town<br />AB1 2CD"
        ]
      )
    end

    it "renders the change links" do
      expect(row_links).to eq(
        [
          "/referrals/#{referral.id}/teacher-role/job-title/edit?return_to=%2F",
          "/referrals/#{referral.id}/teacher-role/duties/edit?return_to=%2F",
          "/referrals/#{referral.id}/teacher-role/duties/edit?return_to=%2F",
          "/referrals/#{referral.id}/teacher-role/same-organisation/edit?return_to=%2F",
          "/referrals/#{referral.id}/teacher-role/start-date/edit?return_to=%2F",
          "/referrals/#{referral.id}/teacher-role/start-date/edit?return_to=%2F",
          "/referrals/#{referral.id}/teacher-role/employment-status/edit?return_to=%2F",
          "/referrals/#{referral.id}/teacher-role/end-date/edit?return_to=%2F",
          "/referrals/#{referral.id}/teacher-role/end-date/edit?return_to=%2F",
          "/referrals/#{referral.id}/teacher-role/reason-leaving-role/edit?return_to=%2F",
          "/referrals/#{referral.id}/teacher-role/working-somewhere-else/edit?return_to=%2F",
          "/referrals/#{referral.id}/teacher-role/work-location-known/edit?return_to=%2F",
          "/referrals/#{referral.id}/teacher-role/work-location/edit?return_to=%2F"
        ]
      )
    end
  end

  context "with some of their role answers as a member of the public" do
    let(:referral) { create(:referral, :public, :teacher_role_public) }

    it "renders the labels" do
      expect(row_labels).to eq(
        [
          "Their job title",
          "How do you want to give details about their main duties?",
          "Description of their role",
          "Do you know the name and address of the organisation where the alleged misconduct took place?",
          "Name and address of the organisation where the alleged misconduct took place"
        ]
      )
    end

    it "renders the values" do
      expect(row_values).to eq(
        [
          "Teacher",
          "Describe their main duties",
          "<p>Teaching children in year 2</p>",
          "Yes",
          "Example School<br />1 Example Street<br />Different Road<br />Example Town<br />AB1 2CD"
        ]
      )
    end

    it "renders the change links" do
      expect(row_links).to eq(
        [
          "/public-referrals/#{referral.id}/teacher-role/job-title/edit?return_to=%2F",
          "/public-referrals/#{referral.id}/teacher-role/duties/edit?return_to=%2F",
          "/public-referrals/#{referral.id}/teacher-role/duties/edit?return_to=%2F",
          "/public-referrals/#{referral.id}/teacher-role/organisation-address-known/edit?return_to=%2F",
          "/public-referrals/#{referral.id}/teacher-role/organisation-address/edit?return_to=%2F"
        ]
      )
    end
  end
end
