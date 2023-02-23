module ComponentHelper
  def remove_actions(items)
    items.map { |item| item.tap { |i| i.delete(:actions) } }
  end
end
