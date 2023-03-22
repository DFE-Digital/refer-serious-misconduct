LogStashLogger.configure { |config| config.customize_event { |event| event["environment"] = Rails.env } }
