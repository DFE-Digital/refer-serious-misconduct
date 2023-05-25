require "rails_helper"

RSpec.describe ManageInterface::AllegationEvidenceComponent, type: :component do
  subject(:component) { described_class.new(referral:) }

  let(:row_labels) { component.rows.map { |row| row.dig(:key, :text) } }
  let(:row_values) { component.rows.map { |row| row.dig(:value, :text) }.map(&:strip) }

  before { render_inline(component) }

  context "with a referral with evidence" do
    let(:referral) { create(:referral, :employer_complete) }

    it "doesn't render any rows" do
      expect(component.rows).to be_nil
    end
  end

  context "with a referral without evidence" do
    let(:referral) { create(:referral) }

    it "renders the correct labels" do
      expect(row_labels).to eq(["Is there anything to upload?"])
    end

    it "renders the correct values" do
      expect(row_values).to eq(["No"])
    end
  end
end
