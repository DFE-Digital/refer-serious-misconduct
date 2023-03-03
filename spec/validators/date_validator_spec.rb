require "rails_helper"

RSpec.describe DateValidator do
  def stub_validatable_class(name, options: true)
    stub_const(name, Class.new).class_eval do
      include ActiveModel::Validations
      attr_accessor :date_params, :the_date
      validates :the_date, date: options
    end
  end

  subject(:model) do
    stub_validatable_class("Validatable")
    Validatable.new
  end

  let(:date_params) do
    { "the_date(1i)" => "2021", "the_date(2i)" => "12", "the_date(3i)" => "25" }
  end

  before { model.date_params = date_params }

  context "with valid date params" do
    it { is_expected.to be_valid }

    it "sets the date on the validated attribute" do
      model.valid?
      expect(model.the_date).to eq(Date.new(2021, 12, 25))
    end
  end

  context "with no date params" do
    let(:date_params) { nil }

    it { is_expected.to be_invalid }
  end

  context "with invalid date params" do
    let(:date_params) do
      { "the_date(1i)" => "-1", "the_date(2i)" => "-1", "the_date(3i)" => "-1" }
    end

    it { is_expected.to be_invalid }
  end

  context "with valid worded params" do
    let(:date_params) do
      {
        "the_date(1i)" => "1990",
        "the_date(2i)" => "September",
        "the_date(3i)" => "seven"
      }
    end

    it { is_expected.to be_valid }
  end

  context "with above_16 option" do
    subject(:model) do
      stub_validatable_class("MinAgeValidatable", options: { above_16: true })
      MinAgeValidatable.new
    end

    context "with valid date params" do
      let(:date_params) do
        {
          "the_date(1i)" => "1990",
          "the_date(2i)" => "12",
          "the_date(3i)" => "25"
        }
      end

      it { is_expected.to be_valid }
    end

    context "with min age date of birth params" do
      let(:date_params) do
        {
          "the_date(1i)" => 15.years.ago.year,
          "the_date(2i)" => "12",
          "the_date(3i)" => "25"
        }
      end

      it { is_expected.to be_invalid }
    end
  end

  context "with past_century option" do
    subject(:model) do
      stub_validatable_class(
        "CenturyValidatable",
        options: {
          past_century: true
        }
      )
      CenturyValidatable.new
    end

    context "with valid date params" do
      let(:date_params) do
        {
          "the_date(1i)" => "1990",
          "the_date(2i)" => "12",
          "the_date(3i)" => "25"
        }
      end

      it { is_expected.to be_valid }
    end

    context "with date params in future" do
      let(:date_params) do
        {
          "the_date(1i)" => 1.year.since.year,
          "the_date(2i)" => "12",
          "the_date(3i)" => "25"
        }
      end

      it { is_expected.to be_invalid }
    end

    context "with year before 1920" do
      let(:date_params) do
        {
          "the_date(1i)" => "1899",
          "the_date(2i)" => "12",
          "the_date(3i)" => "25"
        }
      end

      it { is_expected.to be_invalid }
    end
  end

  context "with required: false option" do
    subject(:model) do
      stub_validatable_class("ReqValidatable", options: { required: false })
      ReqValidatable.new
    end

    context "with empty date params" do
      let(:date_params) do
        { "the_date(1i)" => "", "the_date(2i)" => "", "the_date(3i)" => "" }
      end

      it { is_expected.to be_valid }
    end

    context "with no date params" do
      let(:date_params) { nil }

      it { is_expected.to be_valid }
    end
  end
end
