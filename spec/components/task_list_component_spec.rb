require "rails_helper"

RSpec.describe TaskListComponent, type: :component do
  subject(:rendered) { render_inline(described_class.new(sections:)) }

  let(:sections) do
    [
      OpenStruct.new(
        number: 1,
        label: "Do laundry",
        items: [
          OpenStruct.new(
            label: "Light wash",
            path: "/light-wash",
            status: :completed
          ),
          OpenStruct.new(
            label: "Dark wash",
            path: "/dark-wash",
            status: :not_started_yet
          )
        ]
      ),
      OpenStruct.new(
        number: 2,
        label: "Make a sandwich",
        items: [
          OpenStruct.new(
            label: "Butter bread",
            path: "/butter-bread",
            status: :incomplete
          ),
          OpenStruct.new(
            label: "Add filling",
            path: "/add-filling",
            status: :not_started_yet
          )
        ]
      )
    ]
  end

  it "renders the first numbered section" do
    expect(rendered.css(".app-task-list__section-number")[0].text).to eq("1.")
  end

  it "renders the title in the first numbered section" do
    expect(rendered.css(".app-task-list__section-heading")[0].text).to include(
      "Do laundry"
    )
  end

  it "renders the second numbered section" do
    expect(rendered.css(".app-task-list__section-number")[1].text).to eq("2.")
  end

  it "renders the title in the second numbered section" do
    expect(rendered.css(".app-task-list__section-heading")[1].text).to include(
      "Make a sandwich"
    )
  end

  it "renders the first section title" do
    expect(rendered.css(".app-task-list__item")[0].text).to include(
      "Light wash"
    )
  end

  it "renders the second section title" do
    expect(rendered.css(".app-task-list__item")[1].text).to include("Dark wash")
  end

  it "renders the third section title" do
    expect(rendered.css(".app-task-list__item")[2].text).to include(
      "Butter bread"
    )
  end

  it "renders the fourth section title" do
    expect(rendered.css(".app-task-list__item")[3].text).to include(
      "Add filling"
    )
  end

  it "renders the first link" do
    expect(rendered.css(".app-task-list__item a")[0][:href]).to eq(
      "/light-wash"
    )
  end

  it "renders the second link" do
    expect(rendered.css(".app-task-list__item a")[1][:href]).to eq("/dark-wash")
  end

  it "renders the third link" do
    expect(rendered.css(".app-task-list__item a")[2][:href]).to eq(
      "/butter-bread"
    )
  end

  it "renders the fourth link" do
    expect(rendered.css(".app-task-list__item a")[3][:href]).to eq(
      "/add-filling"
    )
  end

  it "renders the tag with the correct status" do
    expect(rendered.css(".app-task-list__tag")[0].text).to include("Completed")
  end

  it "renders the Not started yet tag with the correct colour" do
    expect(
      rendered.css(".app-task-list__tag.govuk-tag--grey")[0].text
    ).to include("Not started yet")
  end

  it "renders the Incomplete tag with the correct colour" do
    expect(
      rendered.css(".app-task-list__tag.govuk-tag--grey")[1].text
    ).to include("Incomplete")
  end
end
