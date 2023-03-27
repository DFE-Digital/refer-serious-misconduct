class LogStashFormatter < SemanticLogger::Formatters::Raw
  def format_add_type
    hash[:type] = "rails"
  end

  def format_add_hosting_env
    hash[:hosting_environment] = ENV["HOSTING_ENVIRONMENT_NAME"]
  end

  def format_add_host_domain
    hash[:host] = ENV["HOSTING_DOMAIN"]
  end

  # Place a more readable version of the exception into the message field.
  def format_exception
    exception_message = hash.dig(:exception, :message)
    hash[:message] = "Exception occured: #{exception_message}" if exception_message.present?
  end

  def format_stacktrace
    # If the payload usually has a stack trace, that can make
    # the whole object too big in which case Logstash
    # will fail and the log will not be passed
    # We need to trim the stack trace.
    stack_trace = hash.dig(:exception, :stack_trace)

    if stack_trace.present?
      hash[:stacktrace] = stack_trace.first(3)
      hash[:exception].delete(:stack_trace)
    end
  end

  def call(log, logger)
    super(log, logger)

    format_add_type
    format_add_hosting_env
    format_add_host_domain
    format_exception
    format_stacktrace

    hash.to_json
  end
end

if ENV["LOGSTASH_HOST"] && ENV["LOGSTASH_PORT"]
  warn("logstash configured, sending logs there")

  # For some reason logstash / elasticsearch drops events where the payload
  # is a hash. These are more conveniently accessed at the top level of the
  # event, anyway, so we move it there.
  fix_payload =
    proc do |event|
      if event["payload"].present?
        event.append(event["payload"])
        event["payload"] = nil
      end
    end

  log_stash =
    LogStashLogger.new(
      { host: ENV["LOGSTASH_HOST"], port: ENV["LOGSTASH_PORT"], type: :tcp, ssl_enable: true }.merge(
        customize_event: fix_payload
      )
    )
  SemanticLogger.add_appender(logger: log_stash, level: :info, formatter: LogStashFormatter.new)
end
