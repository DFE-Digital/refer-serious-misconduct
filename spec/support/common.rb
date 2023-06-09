def retry_block(error: StandardError, max_attempts: 3, wait: 20)
  attempts = 0
  begin
    yield
  rescue error => e
    attempts += 1
    raise e if attempts >= max_attempts

    sleep(wait)
    retry
  end
end
