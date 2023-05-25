require "rails_helper"

RSpec.describe Referrals::TeacherRoleComponent, type: :component do
  subject(:component) { described_class.new(referral:) }

  let(:referrer) { referral.referrer }
  let(:row_labels) { component.rows.map { |row| row.dig(:key, :text) } }
  let(:row_values) { component.rows.map { |row| row.dig(:value, :text) }.map(&:strip) }
  let(:row_links) { component.rows.map { |row| row.dig(:actions, :href) } }

  before { render_inline(component) }

  context "without their role answers" do
    let(:referral) { create(:referral, :complete) }

    it "renders the labels" do
      expect(row_labels).to eq([])
    end

    it "renders the values" do
      expect(row_values).to eq([])
    end

    it "renders the change links" do
      expect(row_links).to eq([])
    end
  end

  context "with all their role answers" do
    let(:referral) { create(:referral, :complete, :teacher_role_employer) }

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
          "<p>Teaching children in year 2</p>",
          "No",
          "Yes",
          "Example School<br />1 Example Street<br />Different Road<br />Example Town<br />W1 1AA",
          "Yes",
          "10 April 2022",
          "No",
          "Yes",
          "10 March 2023",
          "Dismissed",
          "Yes",
          "Yes",
          "Different School<br />2 Different Street<br />Same Road<br />Example Town<br />W1 1AA"
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
          "<p>Teaching children in year 2</p>",
          "No",
          "Yes",
          "Example School<br />1 Example Street<br />Different Road<br />Example Town<br />W1 1AA",
          "Yes",
          "10 April 2022",
          "No",
          "Yes",
          "10 March 2023",
          "Dismissed",
          "Yes",
          "Yes",
          "Different School<br />2 Different Street<br />Same Road<br />Example Town<br />W1 1AA"
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
          "Example School<br />1 Example Street<br />Different Road<br />Example Town<br />W1 1AA"
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
