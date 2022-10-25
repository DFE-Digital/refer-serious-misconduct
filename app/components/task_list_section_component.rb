class TaskListSectionComponent < ViewComponent::Base
  attr_reader :number, :section

  delegate :label, :items, :path, to: :section

  def initialize(number:, section:)
    super
    @number = number
    @section = section
  end
end
