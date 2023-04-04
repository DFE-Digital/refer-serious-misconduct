LogStashLogger.configure do |config|
  config.customize_event { |event| event["environment"] = Rails.env }
end
