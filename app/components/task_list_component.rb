class TaskListComponent < ApplicationComponent
  attr_reader :sections

  def initialize(sections:)
    super()
    @sections = sections
  end
end
