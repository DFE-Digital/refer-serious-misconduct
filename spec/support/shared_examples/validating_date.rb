# Required values:
# field (via argument) - database date field name, e.g. date_of_birth
# form - the form that has the date field, e.g. let(:form) { described_class.new(referral:, age_known:) }
# referral - a Referral object
# optional - for date fields that are not required

RSpec.shared_examples "form with a date validator" do |field, optional = true|
  subject(:save) { form.save }

  let(:date_field) { referral.send(field) }

  before { save }

  context "when valid date values" do
    let(:date_params) do
      {
        "#{field}(1i)" => "2000",
        "#{field}(2i)" => "01",
        "#{field}(3i)" => "01"
      }
    end

    it "updates the date field" do
      expect(date_field).to eq(Date.new(2000, 1, 1))
    end
  end

  context "with a short month name" do
    let(:date_params) do
      {
        "#{field}(1i)" => "2000",
        "#{field}(2i)" => "Jan",
        "#{field}(3i)" => "01"
      }
    end

    it "updates the date field" do
      expect(date_field).to eq(Date.new(2000, 1, 1))
    end
  end

  context "with a word for a number for the day and month" do
    let(:date_params) do
      {
        "#{field}(1i)" => "2000",
        "#{field}(2i)" => "tWeLvE  ",
        "#{field}(3i)" => "One"
      }
    end

    it "updates the date field" do
      expect(date_field).to eq(Date.new(2000, 12, 1))
    end
  end

  context "without a valid date" do
    let(:date_params) do
      {
        "#{field}(1i)" => "2000",
        "#{field}(2i)" => "02",
        "#{field}(3i)" => "30"
      }
    end

    it { is_expected.to be_falsy }

    it "does not update the date field" do
      expect(date_field).to be_nil
    end

    it "adds an error" do
      expect(form.errors[field.to_s].size).to eq(1)
    end
  end

  context "with a blank date", if: !optional do
    let(:date_params) do
      { "#{field}(1i)" => "", "#{field}(2i)" => "", "#{field}(3i)" => "" }
    end

    it { is_expected.to be_falsey }

    it "adds an error" do
      expect(form.errors[field.to_s].size).to eq(1)
    end
  end

  context "with a year that is less than 4 digits" do
    let(:date_params) do
      { "#{field}(1i)" => "99", "#{field}(2i)" => "1", "#{field}(3i)" => "1" }
    end

    it { is_expected.to be_falsy }

    it "adds an error" do
      expect(form.errors[field.to_s].size).to eq(1)
    end
  end

  context "with a missing day" do
    let(:date_params) do
      { "#{field}(1i)" => "1990", "#{field}(2i)" => "1", "#{field}(3i)" => "" }
    end

    it { is_expected.to be_falsy }

    it "adds an error" do
      expect(form.errors[field.to_s].size).to eq(1)
    end
  end

  context "with a missing month" do
    let(:date_params) do
      { "#{field}(1i)" => "1990", "#{field}(2i)" => "", "#{field}(3i)" => "1" }
    end

    it { is_expected.to be_falsy }

    it "adds an error" do
      expect(form.errors[field.to_s].size).to eq(1)
    end
  end

  context "with a whitespace month" do
    let(:date_params) do
      { "#{field}(1i)" => "1990", "#{field}(2i)" => " ", "#{field}(3i)" => "1" }
    end

    it { is_expected.to be_falsy }

    it "adds an error" do
      expect(form.errors[field.to_s].size).to eq(1)
    end
  end

  context "with a word as a month" do
    let(:date_params) do
      {
        "#{field}(1i)" => "1990",
        "#{field}(2i)" => "Potatoes",
        "#{field}(3i)" => "1"
      }
    end

    it { is_expected.to be_falsy }

    it "adds an error" do
      expect(form.errors[field.to_s].size).to eq(1)
    end
  end
end

RSpec.shared_examples "form with a date of birth validator" do |field|
  subject(:save) { form.save }

  let(:date_field) { referral.send(field) }

  before { save }

  context "when the date is in the future" do
    let(:date_params) do
      {
        "#{field}(1i)" => 1.year.from_now.year,
        "#{field}(2i)" => "01",
        "#{field}(3i)" => "01"
      }
    end

    it { is_expected.to be_falsy }

    it "adds an error" do
      expect(form.errors[field.to_s]).to eq(
        ["Their #{field_name(field)} must be in the past"]
      )
    end
  end

  context "with a date less than 16 years ago" do
    let(:date_params) do
      {
        "#{field}(1i)" => 15.years.ago.year,
        "#{field}(2i)" => Time.zone.today.month,
        "#{field}(3i)" => Time.zone.today.day
      }
    end

    it { is_expected.to be_falsy }

    it "adds an error" do
      expect(form.errors[field.to_s]).to eq(
        ["You must be 16 or over to use this service"]
      )
    end
  end

  context "with a date before 1900" do
    let(:date_params) do
      { "#{field}(1i)" => "1899", "#{field}(2i)" => "1", "#{field}(3i)" => "1" }
    end

    it { is_expected.to be_falsy }

    it "adds an error" do
      expect(form.errors[field.to_s]).to eq(["Enter a year later than 1900"])
    end
  end
end

def field_name(field)
  field.humanize.downcase
end
