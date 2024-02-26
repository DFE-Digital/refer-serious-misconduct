require "rails_helper"

RSpec.describe SupportInterface::EligibilityCheckComponent, type: :component do
  subject(:component) { described_class.new(eligibility_check:) }

  let(:row_labels) { component.rows.map { |row| row.dig(:key, :text) } }
  let(:row_values) { component.rows.map { |row| row.dig(:value, :text) }.map(&:strip) }
  let(:eligibility_check) do
    create(
      :eligibility_check,
      :complete,
      created_at: Time.zone.local(2022, 11, 22, 12, 0, 0),
      updated_at: Time.zone.local(2022, 11, 23, 13, 1, 0)
    )
  end

  context "with an employer referral" do
    it "renders the correct labels" do
      expect(row_labels).to eq(
        [
          "Date started",
          "Date updated",
          "Select if you’re making a referral as an employer or member of public",
          "Select yes if they were employed in England at the time the alleged misconduct took place",
          "Select yes if the allegation involves serious misconduct"
        ]
      )
    end

    it "renders the correct values" do
      expect(row_values).to eq(
        ["22 November 2022 at 12:00 pm", "23 November 2022 at 1:01 pm", "Employer", "Yes", "Yes"]
      )
    end
  end

  context "with a public referral" do
    before do
      travel_to Time.zone.local(2022, 11, 23, 13, 13, 0)
      eligibility_check.update!(reporting_as: "public")
    end

    it "renders the correct labels" do
      expect(row_labels).to eq(
        [
          "Date started",
          "Date updated",
          "Select if you’re making a referral as an employer or member of public",
          "Made an informal complaint",
          "Select yes if they were employed in England at the time the alleged misconduct took place",
          "Select yes if the allegation involves serious misconduct"
        ]
      )
    end

    it "renders the correct values" do
      expect(row_values).to eq(
        [
          "22 November 2022 at 12:00 pm",
          "23 November 2022 at 1:13 pm",
          "Public",
          "No",
          "Yes",
          "Yes"
        ]
      )
    end
  end
end
