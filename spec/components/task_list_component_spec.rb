require "rails_helper"

RSpec.describe TaskListComponent, type: :component do
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

  subject(:rendered) { render_inline(described_class.new(sections:)) }

  it "renders numbered sections" do
    expect(rendered.css(".app-task-list__section-number")[0].text).to eq("1.")
    expect(rendered.css(".app-task-list__section-heading")[0].text).to include(
      "Do laundry"
    )

    expect(rendered.css(".app-task-list__section-number")[1].text).to eq("2.")
    expect(rendered.css(".app-task-list__section-heading")[1].text).to include(
      "Make a sandwich"
    )
  end

  it "renders section items" do
    expect(rendered.css(".app-task-list__item")[0].text).to include(
      "Light wash"
    )
    expect(rendered.css(".app-task-list__item")[1].text).to include("Dark wash")
    expect(rendered.css(".app-task-list__item")[2].text).to include(
      "Butter bread"
    )
    expect(rendered.css(".app-task-list__item")[3].text).to include(
      "Add filling"
    )
  end

  it "renders section item links" do
    expect(rendered.css(".app-task-list__item a")[0][:href]).to eq(
      "/light-wash"
    )
    expect(rendered.css(".app-task-list__item a")[1][:href]).to eq("/dark-wash")
    expect(rendered.css(".app-task-list__item a")[2][:href]).to eq(
      "/butter-bread"
    )
    expect(rendered.css(".app-task-list__item a")[3][:href]).to eq(
      "/add-filling"
    )
  end

  it "renders section item status" do
    expect(rendered.css(".app-task-list__tag")[0].text).to include("Completed")
    expect(rendered.css(".app-task-list__tag")[1].text).to include(
      "Not started yet"
    )
    expect(rendered.css(".app-task-list__tag")[2].text).to include("Incomplete")
    expect(rendered.css(".app-task-list__tag")[3].text).to include(
      "Not started yet"
    )
  end
end
