module ComponentHelper
  def remove_actions(items)
    items.map { |item| item.tap { |i| i.delete(:actions) } }
  end

  def new_item(label:, value:, actions: [])
    item_line = { key: { text: label }, value: { text: value } }

    return item_line.merge(actions:) if actions.any?

    item_line
  end

  def action(path:, label: "Change", options: {})
    action = { text: label, href: path }

    return action.merge(options) if options.present?

    action
  end
end
