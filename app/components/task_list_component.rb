class TaskListComponent < ViewComponent::Base
  attr_reader :sections

  def initialize(sections:)
    super
    @sections = sections
  end
end
