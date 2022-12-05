module TaskListHelpers
  def expect_task_row(section:, item_position:, name:, tag:)
    within(page.find(".app-task-list__section", text: section)) do
      within(all(".app-task-list__item")[item_position - 1]) do
        expect(find(".app-task-list__task-name a").text).to eq(name)
        expect(find(".app-task-list__tag").text).to eq(tag)
      end
    end
  end
end
